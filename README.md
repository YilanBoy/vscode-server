# Build VS Code Server with Terraform

You can quickly build a [vscode server](https://code.visualstudio.com/blogs/2022/07/07/vscode-server) in the AWS with this terraform project

## Usage

> **Note**
>
> You need to install terraform and configure AWS IAM
>

Init the terraform project

```bash
terraform init
```

Check the terraform deploy plan

```bash
terraform plan
```

Start to deploy the vscode server in the AWS cloud

```bash
terraform apply -var="ssh_public_key_filepath=~/.ssh/code_server_rsa.pub"
```

If you have a hosted domain in Route53, you could deploy the server with domain

```bash
terraform apply -var="ssh_public_key_filepath=~/.ssh/code_server_rsa.pub" -var="domain_zone_id=YOUR_DOMAIN_ZONE_ID" -var="domain_name=YOUR_PREFER_DOMAIN_NAME"
```
