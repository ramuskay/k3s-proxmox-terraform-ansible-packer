#############################################################
# Proxmox variables
#############################################################
variable "pm_user" {
  description = "The username for the proxmox user"
  type        = string
  sensitive   = false
  default     = "root@pam"

}
variable "pm_password" {
  description = "The password for the proxmox user"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = false
}

variable "pm_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
}

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}
#############################################################
# Cluster K3S variables
#############################################################

variable "pvt_key" {}

variable "k3s_version" {
  default = "v1.24.3+k3s1"
}

variable "num_k3s_masters" {
  default = 1
}

variable "num_k3s_masters_cpu" {
  default = "2"
}

variable "num_k3s_masters_mem" {
  default = "4096"
}

variable "num_k3s_nodes" {
  default = 2
}

variable "num_k3s_nodes_mem" {
  default = "4096"
}

variable "num_k3s_nodes_cpu" {
  default = "2"
}

variable "template_vm_name" {}

variable "master_ips" {
  description = "List of ip addresses for master nodes"
}

variable "worker_ips" {
  description = "List of ip addresses for worker nodes"
}

variable "networkrange" {
  default = 24
}

variable "gateway" {
  default = "192.168.3.1"
}

#############################################################
# Packer variables
#############################################################

variable "vm_id" {
  description = "Virtual Machine ID number"
  type = number
}

variable "vm_name" {
  description = "Template name"
  default = "packer-template"
  type = string
}

variable "vm_storage_pool" {
  description = "Data store that supports `Disk image` and `Containers` (e.g. storage with type LVM-Thin)"
  type        = string
}

variable "vm_cores" {
  description = "Amount of CPU cores that will be allocated to a VM"
  type = number
  default = 1
}

variable "vm_memory" {
  description = "VM amount of memory"
  type = number
  default = 2048
}

variable "vm_sockets" {
  description = "VM amount of CPU sockets"
  type = number
  default = 1
}

variable "iso_url" {
  description = "Location of ISO file to DL"
  type = string
}

variable "iso_checksum" {
  description = "Checksum for the DL ISO"
  type = string
}

variable "iso_storage_pool" {
  description = "Storage for ISO"
  type = string
  default = "local"
}

variable "http_directory" {
  description = "Directory for autoinstall"
  type = string
  default = "http"
}

variable "username" {
  description = "Username setup"
  type = string
  default = "ubuntu"
}

variable "user_password" {
  description = "Password of the username setup"
  type = string
  default = "password"
}

variable "user_password_hash" {
  description = "The hash of the password of the user"
  type = string
}

variable "ssh_pub_key" {
  description = "The public key for authentication on the user"
  type = string
}

variable "distrib_folder" {
  description = "The folder of our the distrib wihch packer will install" 
  type = string
}

#############################################################
# Ansible variables
#############################################################

variable "inventory_file" {
  description = "Inventory of Ansible"
  type = string
  default = "hosts" 
}

variable "ssh_key_file" {
  description = "The file of the private key for ansible authentication on the user"
  type = string
  default = "~/.ssh/id_rsa"
}

#############################################################
# Module variables
#############################################################

variable "folder_packer" {
  description = "Folder for the packer template creation"
  type = string
  default = "packer"
}
