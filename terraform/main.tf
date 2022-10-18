terraform {  
  required_providers {    
    aws = {      
      source  = "hashicorp/aws"      
      version = "~> 3.27"    
    }  
  }
  required_version = ">= 0.14.9"
}

provider "aws" {  
  region  = "us-east-1"
  allowed_account_ids = ["156914027005"]
}

module "cassandra_rack" { 
    for_each = var.cassandra_racks
    source = "./modules/cassandra-rack"
    aws_key_name = var.aws_key_name
    subnet_id = each.value
    rack_name = each.key
    rack_count = var.rack_count
    security_group_ids = [
        aws_security_group.spark_worker_sg.id,
        aws_security_group.cluster_mgmt_sg.id,
        aws_security_group.cassandra_member_sg.id,
        var.ssh_security_group_id
    ]
    iam_profile = aws_iam_instance_profile.cassandra_node_profile.id
}

