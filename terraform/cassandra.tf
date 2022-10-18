resource "aws_security_group" "cluster_mgmt_sg" {
  name        = "cluster_mgt_sg"
  description = "Spark/Cassandra cluster management"
  vpc_id = var.vpc_id

  ingress {
    description = "reaper-web-ui"
    from_port   = 18080
    to_port     = 18080
    protocol    = "tcp"
    cidr_blocks = [var.cassandra_access_cidr]
  }

  ingress {
    description = "spark-master web-ui"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.cassandra_access_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "cassandra_member_sg" {
  name        = "cassandra_member_sg"
  description = "Allow cassandra members to comunicate with each other"
  vpc_id = var.vpc_id

  ingress {
    description = "cassandra inter-node communication"
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    self = true
  }

  ingress {
    description = "cassandra jmx communication"
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    self = true
  }

  ingress { 
    description = "cassandra inter-node access"
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    self = true
  }

  ingress { 
    description = "cassandra reaper access"
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    security_groups = [ aws_security_group.cluster_mgmt_sg.id ]
  }

  ingress {
    description = "cassandra client access"
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = [var.cassandra_access_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "cluster_mgmt" {
  ami           = "ami-00e87074e52e6c9f9"
  instance_type = "t3.xlarge"
  subnet_id = var.mgmt_subnet_id
  vpc_security_group_ids = [
                            aws_security_group.cluster_mgmt_sg.id,
                            aws_security_group.spark_master_sg.id,
                            var.ssh_security_group_id
                            ]
  iam_instance_profile = aws_iam_instance_profile.cassandra_node_profile.name
  tags = {
    Name = "cluster-mgmt",
  }
  key_name = var.aws_key_name
}
