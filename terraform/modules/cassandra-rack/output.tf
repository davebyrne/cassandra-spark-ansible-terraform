resource "local_file" "ansible_inventory" {
    content = templatefile("rack_inventory.tmpl",
        {
            cassandra_rack = aws_instance.cassandra_rack
        }
    )
    filename = "../ansible/inventory/cassandra-${var.rack_name}"
}
