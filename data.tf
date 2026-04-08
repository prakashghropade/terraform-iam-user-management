data "aws_caller_indetity" "name" {}

 output "account_id" {
    value = data.aws_caller_indetity.name
 }