provider "proxmox" {
  pm_api_url      = "https://proxmox.lan/api2/json"
  pm_user         = "terra@pve"
  pm_password     = "foobar"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "omv" {
  agent       = 1
  balloon     = 0
  bios        = "seabios"
  boot        = "cdn"
  bootdisk    = "scsi0"
  iso         = "local:iso/openmediavault_5.3.9-amd64.iso"
  cores       = 2
  cpu         = "host"
  hotplug     = "network,disk,usb"
  kvm         = true
  memory      = 2048
  name        = "openmediavault"
  numa        = false
  onboot      = true
  qemu_os     = "l26"
  scsihw      = "virtio-scsi-pci"
  sockets     = 2
  target_node = "pve"
  vcpus       = 0
  vmid        = 101

  disk {
    id           = 0
    size         = "32G"
    storage      = "local-lvm"
    storage_type = "lvmthin"
    type         = "scsi"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
}
