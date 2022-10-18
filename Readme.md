# Provision Cassandra/Spark clusters with Terraform/Ansible

Terraform modules and Ansible playbooks to deploy a [Cassandra](https://cassandra.apache.org) cluster with [Apache-Spark](https://spark.apache.org) co-installed on each node.  This best practice allows cassandra data analytics while preserving data-locality.  Each instance of the cluster will also have access to an s3 bucket to read/write data to from spark.  Ansible inventory files are automatically created from terraform.

## Example Usage

### Terraform provisioning
Sample terraform.tfvars
```
s3_bucket_name = "my-s3-bucket"
cassandra_access_cidr = "192.168.0.0/24"
vpc_id = "vpc-eeeeeeee"
rack_count = 4
cassandra_racks = {
    "us_east_1d" = "subnet-dddddddddd"
    "us_east_1e" = "subnet-eeeeeeeeee"
    "us_east_1f" = "subnet-fffffffffff"
}
aws_key_name = "my-keypair"
mgmt_subnet_id = "subnet-cccccccccc"
ssh_security_group_id = "sg-dddddddddd"
```

This will deploy a 12 node cassandra cluster with 4 nodes in 3 different availability zones.  CQL access will be available from the 192.168.0.0/24 cidr.  A management node containing the spark-master is deployed in subnet-ccccccccc.

`ssh_security_group_id` is needed to access the cluster via ssh, using an existing security group. This is required for the ansible deployments.

### Ansible configuration

Update the packages, and install cassandra / apache-spark
```
ansible-playbook -i inventory ./first_boot.yml ./site.yml
```

To bootstrap the cassandra cluster (only needed once)
```
ansible-playbook -i inventory ./cassandra-bootstrap.yml
```

To start the spark cluster:
```
ansible-playbook -i inventory ./spark-start-cluster.yml
```



