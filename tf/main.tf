terraform {
  required_providers {
    proxmox = {
      source  = "telmate.com/tf/proxmox"
      version = "0.1.0"
    }
  }
}

variable "sshkeyfile" {
  type        = string
  description = "ssh pub key for main user"
  default     = "~/.ssh/id_rsa.pub"
}

# variable "omv_user_password" {
#   type        = string
#   description = "password for omv user"
# }

# variable "pve_ssh_user" {
#   type    = string
#   default = "root"
# }

variable "pve_password" {
  type = string
}

# provider "null" {
#   version = "2.1.2"
# }

provider "proxmox" {
  pm_api_url      = "https://proxmox.lan/api2/json"
  pm_user         = "terra@pve"
  pm_password     = var.pve_password
  pm_tls_insecure = true
}

# resource "null_resource" "cloud_init_config_file" {
#   connection {
#     type        = "ssh"
#     user        = var.pve_ssh_user
#     host        = "pve.lan"
#     private_key = file("~/.ssh/id_rsa")
#   }

#   provisioner "file" {
#     content = templatefile("./files/user-cloud.cfg.jinja", {
#       password = var.omv_user_password
#       ssh_key  = file(var.sshkeyfile)
#     })
#     destination = "/var/lib/vz/snippets/user_cloud.cfg"
#   }
# }

# proxmox_vm_qemu.omv:
resource "proxmox_vm_qemu" "omv" {

  agent       = 1
  balloon     = 0
  bios        = "seabios"
  boot        = "c"
  bootdisk    = "scsi0"
  clone       = "omv-template"
  full_clone  = true
  cores       = 2
  cpu         = "host"
  hotplug     = "network,disk,usb"
  kvm         = true
  memory      = 2048
  name        = "omv"
  numa        = false
  onboot      = true
  qemu_os     = "l26"
  scsihw      = "virtio-scsi-pci"
  sockets     = 2
  target_node = "pve1"
  vcpus       = 0

  ipconfig0 = "ip=dhcp,ip6=dhcp"

  ciuser  = "berkeleytrue"
  sshkeys = file(var.sshkeyfile)
  os_type = "cloud-init"

  disk {
    id           = 0
    size         = "32G"
    storage      = "local-lvm"
    storage_type = "lvmthin"
    type         = "scsi"
  }

  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = "76:60:11:E4:18:36"
  }

  lifecycle {
    ignore_changes = [
      cipassword,
    ]
  }
}
