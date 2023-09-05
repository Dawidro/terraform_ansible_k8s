terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vmpool" {
  name = "cloud-pool"
  type = "dir"
  path = "/opt/volume"
}

resource "libvirt_volume" "vm-qcow2" {
  count  = var.hosts
  name   = "${var.vm_name[count.index]}.qcow2"
  pool   = libvirt_pool.vmpool.name
  source = "${path.module}/sources/${var.vm_name[count.index]}.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" { 
  count     = var.hosts
  name      = "commoninit-${var.vm_name[count.index]}.iso"
  pool      = libvirt_pool.vmpool.name
  user_data = templatefile("${path.module}/templates/user_data.tpl", {
      host_name = var.vm_name[count.index]
      host_key  = tls_private_key.id_rsa_host.public_key_openssh
      vm_key = tls_private_key.id_rsa_vm.public_key_openssh
  })  
  
  network_config =   templatefile("${path.module}/templates/network_config.tpl", {
     interface = var.interface
     ip_addr   = var.ips[count.index]
     mac_addr = var.macs[count.index]
  })
}

resource "libvirt_domain" "cloud-domain" {
  count  = var.hosts
  name   = var.vm_name[count.index]
  memory = var.memory
  vcpu   = var.vcpu  
  
  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)
  
  network_interface {
      network_name = "default"
      addresses    = [var.ips[count.index]]
      mac          = var.macs[count.index]
  }  
  
  console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
  }  
  
  console {
      type        = "pty"
      target_port = "1"
      target_type = "virtio"
  } 
  
  disk {
      volume_id = element(libvirt_volume.vm-qcow2.*.id, count.index)
  }
}

# ssh keys for host
resource "tls_private_key" "id_rsa_host" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "ssh_private_key" {
    content = tls_private_key.id_rsa_host.private_key_pem
    filename             = pathexpand("~/.ssh/id_rsa_vm")
    directory_permission = "700"
    file_permission      = "600"
}

resource "local_sensitive_file" "ssh_public_key" {
    content = tls_private_key.id_rsa_host.public_key_openssh
    filename             = pathexpand("~/.ssh/id_rsa_vm.pub")
    directory_permission = "700"
    file_permission      = "644"
}

# ssh keys for vms
resource "tls_private_key" "id_rsa_vm" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "ssh_private_key_vm" {
    content = tls_private_key.id_rsa_vm.private_key_pem
    filename          = "${path.module}/id_rsa"
}

resource "local_sensitive_file" "ssh_public_key_vm" {
    content = tls_private_key.id_rsa_vm.public_key_openssh
    filename          = "${path.module}/id_rsa.pub"
}

resource "null_resource" "local_execution" {
  provisioner "remote-exec" {
       connection {
           user = "vmadmin"
           host = var.ips[0]
           type     = "ssh"
           private_key = tls_private_key.id_rsa_host.private_key_pem
       }

       inline = [
           "echo '${nonsensitive(tls_private_key.id_rsa_vm.private_key_pem)}' > /home/vmadmin/.ssh/id.rsa",
           "chmod 600 /home/vmadmin/.ssh/id.rsa",
           "sudo apt-mark hold linux-image-amd64 libc6 dbus systemd udev",
           "sudo apt update",
           "sudo apt-get -y install git",
           "sudo apt-get -y install ansible",
           "sudo apt-get -y install python3-pip",
           "git clone https://github.com/Dawidro/ansible_kubernetes",
           "git clone https://github.com/Dawidro/k8s_labs",
           "cd /home/vmadmin/ansible_kubernetes/roles",
           "git clone https://github.com/Dawidro/ansible-role-cri_o",
           "git clone https://github.com/Oefenweb/ansible-ufw",
           "git clone https://github.com/Dawidro/update_debian",
           "echo '[defaults]\nhost_key_checking = False\nprivate_key_file = /home/vmadmin/.ssh/id.rsa\nremote_user = vmadmin' >> /home/vmadmin/.ansible.cfg",
           "sudo apt-mark unhold linux-image-amd64 libc6 dbus systemd udev",
#           "sudo apt-mark unhold libc6",
           "ansible-galaxy collection install kubernetes.core",
           "cd /home/vmadmin/ansible_kubernetes",
           "ansible all -i hosts -m ping -v",
           "ansible-playbook -i hosts all.yml",
           "ansible-playbook -i hosts master.yml",
           "ansible-playbook -i hosts workers.yml"
       ]
   }
}
