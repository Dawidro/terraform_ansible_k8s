#cloud-config
# vim: syntax=yaml
hostname: ${host_name}
manage_etc_hosts: true
users:
  - name: vmadmin
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      -  ${host_key}
      -  ${vm_key}
    shell: /bin/bash
    lock_passwd: false    
ssh_pwauth: false
disable_root: true
chpasswd:
  list: |
    vmadmin:Pa$$w0rd
  expire: false
growpart:
  mode: auto
  devices: ['/']
