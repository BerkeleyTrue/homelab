provider "proxmox" {
  pm_api_url      = "https://proxmox.lan/api2/json"
  pm_user         = "terra@pve"
  pm_password     = "foobar"
  pm_tls_insecure = true
}

# proxmox_vm_qemu.omv:
resource "proxmox_vm_qemu" "omv" {
  agent       = 1
  balloon     = 0
  bios        = "seabios"
  boot        = "c"
  bootdisk    = "scsi0"
  clone       = "openmediavault"
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
  target_node = "pve"
  vcpus       = 0

  ipconfig0 = "ip=dhcp,ip6=dhcp"

  ciuser = "berkeleytrue"

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
      sshkeys,
    ]
  }
}
