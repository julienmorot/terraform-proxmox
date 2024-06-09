resource "proxmox_vm_qemu" "cloudinit-test" {
  name        = "terraform-test-vm"
  desc        = "A test for using terraform and cloudinit"
  target_node = "ns33672748"
  clone       = "tpl-ubuntu-2204"
  full_clone  = "true"
  bios        = "ovmf"

  agent = 1

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  vcpus    = 0
  cpu      = "host"
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  boot     = "order=virtio0"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size     = 20
          cache    = "writeback"
          storage  = "local"
          iothread = true
          discard  = true
        }
      }
    }
  }


  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  ipconfig0    = "ip=192.168.69.120/24,gw=192.168.69.1"
  nameserver   = "192.168.69.1"
  searchdomain = "morot.local"
}
