# Needed for Terraform to function
# Both keys will need to be replaced with a better system down the line

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
   tags = {
     "Cost Center" = "${data.local_file.client-name-file.content}"
   }
   }
}