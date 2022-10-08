data "template_file" "inventory" {
  template = file("./inventory.tpl")
  depends_on = [
    oci_core_instance.instance_arm1,
    oci_core_instance.instance_int1,
    oci_core_instance.instance_arm2
  ]
  vars = {
    inv_arm1      = "${var.instance_arm1_hostname} ansible_host=${oci_core_instance.instance_arm1.public_ip} ansible_user='ubuntu'"
    inv_arm2      = "${var.instance_arm2_hostname} ansible_host=${oci_core_instance.instance_arm2.public_ip} ansible_user='ubuntu'"
    inv_int1      = "${var.instance_int1_hostname} ansible_host=${oci_core_instance.instance_int1.public_ip} ansible_user='ubuntu'"
    inv_global = " ansible_python_interpreter='/usr/bin/python3' \n ansible_ssh_private_key_file='/home/jay/code/oci-jay/base/key.pem'"
    inv_ubuntu = "${var.instance_arm1_hostname} \n ${var.instance_arm2_hostname} \n ${var.instance_int1_hostname}"
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