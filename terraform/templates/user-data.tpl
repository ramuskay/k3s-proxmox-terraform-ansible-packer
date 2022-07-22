#cloud-config
autoinstall:
  version: 1
  locale: en_US
  keyboard:
    layout: fr
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - qemu-guest-agent
  user-data:
    users:
        - name: ${SUDO_USERNAME}
          passwd: ${SUDO_PASSWORD_HASH}
          groups: [adm, cdrom, dip, plugdev, lxd, sudo]
          lock-passwd: false
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${SSH_PUBLIC_KEY}