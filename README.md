# Crée un cluster K3s en mode IaC avec les outils Hashicorp

## Requirements

## Requirements ##

| Name          | Version |
|---------------|---------|
| proxmox       | \>= 6.2 |
| terraform     | \>= 0.13 |
| packer        | \>= 1.6.5 |
| python        | \>= 3.0  |
| pip           | \>= 20.0 |
| - [`proxmoxer`](https://github.com/proxmoxer/proxmoxer)           | \>= 1.1.1 |
| - [`requests`](https://pypi.org/project/requests/) | \>= 2.24.0|

## How to
For more details check out my [blog](https://blog.beerus.fr/deploy-k3s-proxmox).

### Terraform setup

Everithing goes though Terraform, you may need to configure it. For it modify the file **terraform.tfvars**  
It contains the vars for :
- Terraform
- Packer
- Ansible
- K3S

And when you have set all the vars you want you can launch Terraform :

```bash
terraform init
terraform plan 
terraform apply 
```

It can take some time to create the servers on Proxmox but you can monitor them over Proxmox.
There will be the following steps : 
- Creating packer conf files
- Launch packer job
- Launch terraform job
- Creating ansible conf files
- Launch ansible job

### Manual Packer setup

The k3s cluster will be installed under Ubuntu20.04, if you want to install another distribution you just have to create a subfolder under the packer folder. Then retrieve the ubuntu20.04 configuration, pu it there and tweak them 

If you don't want to do it trough Terraform you can manually start creating the pakcer image using the following commands:

```bash
# cd to the project packer folder
cd packer

# start packer
packer build .
```

### Manual Ansible setup


After you run the Terrafom file, your file should look like this:

```bash
[master]
192.168.3.200 Ansible_ssh_private_key_file=~/.ssh/proxk3s

[node]
192.168.3.202 Ansible_ssh_private_key_file=~/.ssh/proxk3s
192.168.3.201 Ansible_ssh_private_key_file=~/.ssh/proxk3s
192.168.3.198 Ansible_ssh_private_key_file=~/.ssh/proxk3s
192.168.3.203 Ansible_ssh_private_key_file=~/.ssh/proxk3s

[k3s_cluster:children]
master
node
```

If you don't want to do it trough Terraform you can manually start provisioning the cluster using the following commands:

```bash
# cd to the project ansible folder
cd ansible

# run the playbook
ansible-playbook -i hosts playbook.yml
```

It can a few minutes, but once its done, you should have a k3s cluster up and running.

### Kubeconfig

The ansible should already copy the file to your ~/.kube/config (if you enable the ```copy_kubeconfig``` in  ```inventory/my-cluster/group_vars/all.yml```), but if you are having issues you can scp and check the status again.

```bash
scp ubuntu@master_ip:~/.kube/config ~/.kube/config
```
