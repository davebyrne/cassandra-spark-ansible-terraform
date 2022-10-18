variable "aws_key_name" { type = string }
variable "subnet_id" { type = string }
variable "rack_count" { type = number }
variable "security_group_ids" { type = set(string)}
variable "iam_profile" { type = string }
variable "rack_name" { type = string }