resource "proxmox_vm_qemu" "cloudinit-test" {
  name = "terraform-test-vm"
  desc = "A test for using terraform and cloudinit"
  target_node = "ns33672748"
  clone       = "tpl-ubuntu-2204"

  agent = 1

  os_type = "cloud-init"
  cores   = 2
  sockets = 1
  vcpus   = 0
  cpu     = "host"
  memory  = 2048
  scsihw  = "lsi"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 32
          cache   = "writeback"
          storage = "local"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  boot = "order=scsi0"
  ipconfig0 = "ip=192.168.69.120/24,gw=192.168.69.1"
}
