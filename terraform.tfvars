#############################################################
# Proxmox API variables
#############################################################

pm_host = "https://192.168.2.100:8006"
pm_user = "root@pam"
pm_password = "Azer-1234"
pm_node_name = "canadium"
pm_tls_insecure = true
pvt_key = "~/.ssh/ansible_rsa"

#############################################################
# Cluster K3S variables
#############################################################

k3s_version = "v1.24.3+k3s1"
num_k3s_masters = 1
num_k3s_masters_mem = 2048
num_k3s_masters_cpu = 2
num_k3s_nodes = 2
num_k3s_nodes_mem = 2048
num_k3s_nodes_cpu = 2
template_vm_name = "ubuntu-20.04"
master_ips = [
  "192.168.2.102"
]
worker_ips = [
  "192.168.2.103",
  "192.168.2.104",
]
gateway = "192.168.2.1"


#############################################################
# Packer variables
#############################################################

# iso_url = "local:iso/ubuntu-20.04.4-live-server-amd64.iso"
iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
iso_storage_pool = "local"
iso_checksum = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
http_directory = "http"
vm_name = "ubuntu-20.04"
vm_id = 9999
vm_storage_pool = "local-lvm"
username = "canadium"
user_password = "ubuntu"
user_password_hash = "$6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0"
ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCo9n+WpaL7DapKUdpQyeQ1UxZg2ovqKleek+qYoLwvz8hyHhT+It+PugxVY2vGCZww1HFgVI9q3y4zqX9ysw/idDGlugKe2yPla6tNm4KN/z70hrV48UCodkHdXa+thAV7SgsbEiKMJ/uUTMiMeUXUqXoTictUxl0v2vtXUQZK+bTe5IEfCcz6y0/f3IQQG31ODGnlCT5aVQZ9TSYD9LcMuISI4xTgCmoF+5eLDemNKxTGzDB1V6P2fyFD4UvovxPbVzjU+wPRt+pN/ft+4VoyHRC2O1BEZXc90sfItuQRM5AOL2DHK1BkCTgBG4WozRTPZaEhgmd9u+kLupYD+h0gablBPOV3WPBkixJX/gOQlqCPwXXgWmezRsM7R3cJdPPkOtkb9XKudBQd6Z3I7MFWgmGGJf1UJ/CQpMWIPuhROTimeyRMXh1YQt1FURb/DxuJbTuYpUGmHwqxqiJ7k+Zg/DNxQHEaI7JND36HFpMu6MDwxDqHnb2i52XYbu8vCx8="
distrib_folder = "ubuntu20.04" 

#############################################################
# Ansible variables
#############################################################

ssh_key_file = "~/.ssh/ansible_rsa"
inventory_file = "hosts"

#############################################################
# Module variables
#############################################################

folder_packer = "packer"
