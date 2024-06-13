resource "proxmox_cloud_init_disk" "ci" {
  name     = "terraform-test-vm"
  pve_node = "ns33672748"
  storage  = "local"

  meta_data = yamlencode({
    instance_id    = sha1("terraform-test-vm")
    local-hostname = "terraform-test-vm"
  })

  user_data = <<EOT
#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
 - screen
 - htop
manage_etc_hosts: localhost
ssh_pwauth: True

EOT

  network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "ens18"
      subnets = [{
        type            = "static"
        address         = "192.168.69.120/24"
        gateway         = "192.168.69.1"
        dns_nameservers = ["192.168.69.1"]
      }]
    }]
  })
}

resource "proxmox_vm_qemu" "cloudinit-test" {
  name        = "terraform-test-vm"
  desc        = "A test for using terraform and cloudinit"
  target_node = "ns33672748"
  clone       = "tpl-ubuntu-2204"
  full_clone  = "true"
  bios        = "seabios"

  agent         = 1
  agent_timeout = 120
  skip_ipv6     = true

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  vcpus    = 0
  cpu      = "host"
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  boot     = "order=virtio0"

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:${proxmox_cloud_init_disk.ci.id}"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = 30
          storage = "local"
        }
      }
    }
  }


  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
}
