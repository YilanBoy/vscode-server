# because the key and region are already set in the environment
# there is no need to put anything here (it is also not recommended to set the key in the hardcode way)
# there is no problem to delete this porvider block directly
provider "aws" {
  region = "ap-northeast-2"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

# in multi-person collaboration, terraform's best practice recommends using state lock and remote state
# there is no problem to delete this block, only means that we are using local state here
terraform {
  # ref: <https://www.terraform.io/language/settings/backends/s3>
  backend "s3" {
    bucket         = "terraform-state-archives"
    key            = "vs-code-server-terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "vs-code-state-locking"
  }
}
