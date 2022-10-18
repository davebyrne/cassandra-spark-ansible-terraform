resource "local_file" "ansible_inventory" {
    content = templatefile("inventory.tmpl",
        {
            cluster_mgmt = aws_instance.cluster_mgmt
        }
    )
    filename = "../ansible/inventory/cassandra"
}
