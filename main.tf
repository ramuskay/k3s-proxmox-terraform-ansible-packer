locals {
  template_folder = "${path.module}/${var.folder_packer}/${var.distrib_folder}"
  packer_cfg = {
    PKR_VAR_proxmox_hostname  = var.pm_host
    PKR_VAR_proxmox_username  = var.pm_user
    PKR_VAR_proxmox_password  = var.pm_password
    PKR_VAR_proxmox_node_name = var.pm_node_name
    PKR_VAR_proxmox_insecure_skip_tls_verify = var.pm_tls_insecure

    PKR_VAR_vm_id                 = var.vm_id
    PKR_VAR_vm_name               = var.vm_name
    PKR_VAR_vm_storage_pool       = var.vm_storage_pool
    PKR_VAR_vm_cores              = var.vm_cores
    PKR_VAR_vm_memory             = var.vm_memory
    PKR_VAR_vm_sockets            = var.vm_sockets

    PKR_VAR_iso_url             = var.iso_url
    PKR_VAR_iso_storage_pool    = var.iso_storage_pool
    PKR_VAR_iso_checksum        = var.iso_checksum

    PKR_VAR_http_directory      = var.http_directory

    PKR_VAR_username              = var.username
    PKR_VAR_user_password         = var.user_password
  }
}

resource "null_resource" "packer_build" {
  provisioner "local-exec" {
    working_dir = local.template_folder
    command     = "packer build . && sleep 30"
    environment = local.packer_cfg
  }
  provisioner "local-exec" {
    when  = destroy
    command = "${path.module}/scripts/delete_template.py"
    interpreter = ["python"]
    working_dir = path.module
    environment = merge(yamldecode(self.triggers.packer_cfg))
  }
    triggers = {
    packer_cfg = yamlencode(local.packer_cfg)
  }
  depends_on = [
    local_file.user-data
  ]
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = var.num_k3s_masters
  name        = "k3s-master-${count.index}"
  target_node = var.pm_node_name
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = var.num_k3s_masters_cpu

  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.networkrange},gw=${var.gateway}"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      desc,
      network
    ]
  }
  
  connection {
    type = "ssh"
    user = var.username
    password = var.user_password
    host = var.worker_ips[count.index]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/wait-cloud-init.sh"
    destination = "/tmp/wait-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/wait-cloud-init.sh",
      "/tmp/wait-cloud-init.sh",
    ]
  }
  depends_on = [
    null_resource.packer_build
  ]
}



resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = var.num_k3s_nodes
  name        = "k3s-worker-${count.index}"
  target_node = var.pm_node_name
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = var.num_k3s_nodes_cpu

  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.networkrange},gw=${var.gateway}"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      desc,
      network
    ]
  }

  connection {
    type = "ssh"
    user = var.username
    password = var.user_password
    host = var.worker_ips[count.index]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/wait-cloud-init.sh"
    destination = "/tmp/wait-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/wait-cloud-init.sh",
      "/tmp/wait-cloud-init.sh",
    ]
  }

  depends_on = [
    null_resource.packer_build
  ]
}

// Create cloud-init subiquity file from template
data "template_file" "cloud-init-user-data" {
    template = "${file("${path.module}/templates/user-data.tpl")}"
    vars = {
        SUDO_PASSWORD_HASH = "${var.user_password_hash}"
        SUDO_USERNAME = "${var.username}"
        SSH_PUBLIC_KEY = "${var.ssh_pub_key}"
    }
}
// Write template result to http mount directory
resource "local_file" "user-data" {
    content     = "${data.template_file.cloud-init-user-data.rendered}"
    filename = "${local.template_folder}/http/user-data"
}

data "template_file" "k8s" {
  template = "${file("${path.module}/templates/k8s.tpl")}"
  vars = {
    k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
  }
}

resource "local_file" "k8s_file" {
  content  = data.template_file.k8s.rendered
  filename = "${path.module}/ansible/hosts"
}

data "template_file" "groups_vars_ansible" {
    template = "${file("${path.module}/templates/all.tpl")}"
    vars = {
        ANSIBLE_USER = "${var.username}"
        K3S_VERSION = "${var.k3s_version}"
    }
}

resource "local_file" "groups_vars_ansible" {
    content     = "${data.template_file.groups_vars_ansible.rendered}"
    filename = "${path.module}/ansible/group_vars/all.yml"
}

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ${var.inventory_file} --private-key ${var.ssh_key_file} playbook.yml"
    working_dir = "${path.module}/ansible/"
  }
  depends_on = [
    proxmox_vm_qemu.proxmox_vm_workers,
    proxmox_vm_qemu.proxmox_vm_master,
    local_file.k8s_file,
    local_file.groups_vars_ansible
  ]
}
