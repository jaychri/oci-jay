variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "ssh_public_key" {}

# variable "compartment_ocid" {}
# variable "region" {}

variable "hostname" {
  default = "docker"
}