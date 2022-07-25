# General notes

Start vscode from within WSL

    code .

## OCI command line

[document link](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliusing.htm#Using_the_CLI)

Install OCI CLI
  - use defaults

```
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
```

Some OCI commands:

| Command | Description|
| ------- | --------------------|
| `oci --version` | version |
| `oci setup config` |  configure (will generate keys to add to user's API Key list|
| `oci setup keys`  | generate keypair to include in the config file.

## CLI with Token based authentication

 - [Documentation link](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/clitoken.htm#Tokenbased_Authentication_for_the_CLI)

 `oci session authenticate`

 `oci session validate --config-file <path_to_config_file> --profile <profile_name> --auth security_token`

`oci session refresh --profile <profile_name>`

Add `--output table` to return a table

To use token:

`oci iam region list --profile jay-token --auth security_token`

 ## Installing Terraform (Ubuntu/Debian)

 ```
 curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
 sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
 sudo apt-get update && sudo apt-get install terraform
 ```