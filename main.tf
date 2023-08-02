terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Nginx Container
resource "docker_container" "nginx" {
  name  = "nginx-container"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
  volumes {
    host_path      = "${path.module}/nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
}

# MariaDB Container
resource "docker_container" "mariadb" {
  name  = "mariadb-container"
  image = "mariadb:latest"
  env   = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}"
  ]
  ports {
    internal = 3306
    external = 3306
  }
}
