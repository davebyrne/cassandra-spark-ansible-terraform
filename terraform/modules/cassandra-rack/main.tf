
resource "aws_instance" "cassandra_rack" { 
  key_name = var.aws_key_name
  ami           = "ami-00e87074e52e6c9f9"
  instance_type = "i3.2xlarge"
  subnet_id = var.subnet_id
  count = var.rack_count
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile = var.iam_profile
  root_block_device {
    volume_size = 32
    delete_on_termination = true
  }
  tags = {    
    Name = "cassandra-{$var.rack_name}-${count.index + 1}",
  }
}
