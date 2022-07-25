# This terraform code parses the ~/.oci/config file to populate configured profiles into terraform allowing values in there to be used in terraform
locals {
  # Read the file from disk and split it into an array of lines
  cflines = split("\n", file(pathexpand("~/.oci/config")))
  # First, identify the profile headings - they're standard INI format surrounded by square braces e.g [DEFAULT]
  ocipf = [for line in local.cflines : flatten(regexall("\\[([\\w]+)\\]", line))]
  # turn the profile headings into a compact list of the line indices of the headings
  ociln = compact([for i in range(length(local.ocipf)) : length(local.ocipf[i]) > 0 ? i : ""])
  # generate an off-by-one copy of the above list and append the "end of the file" length to it
  ociln2 = concat(slice(local.ociln, 1, length(local.ociln)), [length(local.cflines)])
  # slice the original lines into an indexed map keyed by the profile name
  ocilns = { for i in range(length(local.ociln)) : element(local.ocipf, local.ociln[i])[0] => slice(local.cflines, local.ociln[i] + 1, local.ociln2[i] - 1) }
  # for each profile, flatten out the key-value pairs in each profile into a key=>value map
  oci_profiles = { for k, v in local.ocilns : k => { for line in compact(v) : flatten(regexall("(?P[\\w]+)=(?P.+)$", line))[0]["key"] => flatten(regexall("(?P[\\w]+)=(?P.+)$", line))[0]["value"] } }
}

variable "profile_name" {
  description = <<-EOD
    Name of profile from OCI file (defaults to DEFAULT)
    EOD
  type        = string
  default     = "DEFAULT"
}

# Initialize the OCI provider with specified profile name
provider "oci" {
  config_file_profile = local.profile
}

# Build the data from the oci file profile into oci_data. Can be queried later
locals {
  oci_data = { for k, v in local.oci_profiles[local.profile] : k => v if !contains(["fingerprint", "key_file", "passphrase"], k) }
}

# Build a data query for the user information for the OCI user
data "oci_identity_user" "user_info" {
    user_id = local.oci_data.user
}

# Output the found user information
output "oci_user" {
    value = data.oci_identity_user.user_info
}
