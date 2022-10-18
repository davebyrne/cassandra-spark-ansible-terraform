variable "vpc_id" { type = string }
variable "aws_key_name" { type = string }

variable "s3_bucket_name" { 
    type = string 
    description = "name of s3 bucket that spark/cassandra will be able to read and write from"
}
variable "cassandra_access_cidr" { 
    type = string 
    description = "cidr block to allow cql access to"
}
variable "rack_count" { 
    type = number 
    description = "number of nodes per rack"
}
variable "cassandra_racks" { 
    type = map 
    description = "key value of rack-name and subnet id for each rack"
}

variable "mgmt_subnet_id" { 
    type = string 
    description = "subnet to contain cluster management node"
}
variable "ssh_security_group_id" { 
    type = string 
    description = "security group that allows ssh access for instance management"
}