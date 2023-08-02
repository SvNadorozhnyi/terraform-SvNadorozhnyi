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
    internal = 8080
    external = 8080
  }
  
  upload {
    source = "index.html"
    file = "/usr/share/nginx/html/index.html"
  }
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
    "MYSQL_DATABASE=mydb",
    "MYSQL_USER=myuser",
  ]
}

variable "db_root_password" {
  description = "Root password for the MariaDB container"
  default = "defaultpassword"
}
