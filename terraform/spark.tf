
resource "aws_security_group" "spark_worker_sg" { 
  name        = "spark_worker_sg"
  description = "Allow spark workers to communicate"
  vpc_id = var.vpc_id

   //spark uses random ports... this port is set in spark-env.sh on the worker
  ingress {
    description = "spark worker-ports communication"
    from_port   = 26969
    to_port     = 26969
    protocol    = "tcp"
    self = true
  }

}


resource "aws_security_group" "spark_master_sg" { 
  name        = "spark_master_sg"
  description = "Allow spark workers to communicate"
  vpc_id = var.vpc_id

  ingress {
    description = "spark master port (by external drivers and workers)"
    from_port   = 7077
    to_port     = 7077
    protocol    = "tcp"
    security_groups = [ aws_security_group.spark_worker_sg.id ]
  }
  
}