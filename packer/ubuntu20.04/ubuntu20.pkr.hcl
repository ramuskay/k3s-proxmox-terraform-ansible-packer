source "proxmox" "template" {
  proxmox_url = "${var.proxmox_hostname}/api2/json"
  username = var.proxmox_username
  password = var.proxmox_password
  node = var.proxmox_node_name
  insecure_skip_tls_verify = var.proxmox_insecure_skip_tls_verify
  network_adapters {
    bridge = "vmbr0"
  } 
  disks {
    type = "scsi"
    disk_size = "20G"
    storage_pool = var.vm_storage_pool
    storage_pool_type = "lvm-thin"
    format = "raw"
  }
  iso_file = "local:iso/ubuntu-20.04.4-live-server-amd64.iso"
  # iso_url               = var.iso_url
  # iso_storage_pool      = var.iso_storage_pool
  # iso_checksum          = var.iso_checksum
  unmount_iso = true
  boot_wait = "5s"
  cloud_init = true
  cloud_init_storage_pool = var.vm_storage_pool
  memory = var.vm_memory
  sockets   = var.vm_sockets
  cores     = var.vm_cores
  template_name = var.vm_name
  vm_id     = var.vm_id
  http_directory = var.http_directory
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>", 
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]
  ssh_username = var.username
  ssh_password = var.user_password
  ssh_timeout = "20m"
}

build {
  sources = [
    "source.proxmox.template"
  ]
  provisioner "shell" {
    inline = [
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo cloud-init clean"
    ]
  }
}
