data "template_file" "inventory" {
  template = file("./inventory.tpl")
  depends_on = [
    oci_core_instance.instance0,
    oci_core_instance.instance1
  ]
  vars = {
    inv_0      = "${var.instance0_hostname} ansible_host=${oci_core_instance.instance0.public_ip} ansible_user='ubuntu'"
    inv_1      = "${var.instance1_hostname} ansible_host=${oci_core_instance.instance1.public_ip} ansible_user='ubuntu'"
    inv_global = " ansible_python_interpreter='/usr/bin/python3' \n ansible_ssh_private_key_file='/home/jay/code/oci-jay/base/key.pem'"
  }
}

resource "null_resource" "inventory" {
  triggers = {
    template_rendered = data.template_file.inventory.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ../ansible/inventory.new"
  }
}