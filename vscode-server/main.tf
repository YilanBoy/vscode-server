# 這裡可以說明要使用 AWS Provider
# 因為 Key 與 Region 都已在環境中設定好，因此這裡不需要放入任何內容 (也不建議用 Hardcode 的方式設定 Key)
# 直接刪除這段也沒有問題
provider "aws" {
  region = "ap-northeast-2"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

# 在多人協作，Terraform 的 Best Practice 建議使用 State Lock 與 Remote State
# 這段刪除沒有任何影響，僅僅代表不使用 State Lock 與使用 Local State
# terraform {
#   # ref: <https://www.terraform.io/language/settings/backends/s3>
#   backend "s3" {
#     bucket         = "terraform-state-archives"
#     key            = "vs-code-server-terraform.tfstate"
#     region         = "ap-northeast-2"
#     dynamodb_table = "vs-code-state-locking"
#   }
# }
