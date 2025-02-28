k3s_version: ${K3S_VERSION} #v1.22.2+k3s1
ansible_user: ${ANSIBLE_USER}
systemd_dir: /etc/systemd/system
master_ip: "{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
extra_server_args: "--write-kubeconfig-mode=644"
extra_agent_args: ""
copy_kubeconfig: true
metallb: false
metallb_version: "v0.12.1"
metallb_range: "192.168.3.93-192.168.3.94"
argocd: false
argocd_service_type: LoadBalancer
dns_servers: []
