
resource "google_compute_firewall" "allow_prefect_ports" {
  name    = "allow-prefect-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "3000", "4200", "5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Allow SSH, HTTP app, and other custom ports"
}


resource "google_compute_instance" "postgresql_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  tags = var.tags 
  metadata = {
    description = var.description
  }
  labels = {
  env         = var.environment
  description = var.description
}


  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  scheduling {
    provisioning_model = "SPOT" # ✅ Recomendado (nuevo)
    preemptible        = true   # 👈 Requerido para compatibilidad
    automatic_restart  = false  # 👈 Spot VMs no deben reiniciarse
  }

  network_interface {
    network = "default"
    access_config {}
  }

  #    attached_disk {
  #    #source      = google_compute_disk.data_disk.self_link
  #    source      = "projects/${var.project}/zones/${var.zone}/disks/storage-postgresql-disk"
  #    device_name = "data-disk"
  #    mode        = "READ_WRITE"
  #  }

  #  metadata = {
  #    ssh-keys = "debian:${file("${path.module}/id_rsa.pub")}"
  #  }

  #}

  #resource "local_file" "ansible_inventory" {
  #  content  = <<-EOT
  #    [postgresql]
  #    vm-postgresql ansible_host=${google_compute_instance.postgresql_instance.network_interface[0].access_config[0].nat_ip} ansible_user=debian ansible_ssh_private_key_file=~/.ssh/id_rsa
  #  EOT
  #  filename = "${var.path_ansible}/inventory.ini"
}
