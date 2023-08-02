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

resource "docker_container" "nginx" {
  name  = "nginx_container"
  image = "nginx:latest"

  ports {
    internal = 80
    external = 8080
  }

  env = [
    "NGINX_PORT=8080",
    "RESPONSE_TEXT=My First and Lastname: <Your first and lastname>",
  ]
}

resource "docker_container" "mariadb" {
  name  = "mariadb_container"
  image = "mariadb:latest"

  ports {
    internal = 3306
    external = 3306
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
  ]
}

variable "db_root_password" {
  description = "Root password for the MariaDB container"
  default = "defaultpassword"
}
