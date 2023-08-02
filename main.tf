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

data "template_file" "index_html" {
  template = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
        <title>My First and Lastname</title>
    </head>
    <body>
        <h1>My First and Lastname: Sviatoslav Nadorozhnyi</h1>
    </body>
    </html>
  EOT
}

resource "docker_volume" "nginx_volume" {
  name = "nginx_html_volume"
}

  env = [
    "NGINX_PORT=8080",
  ]
  
volumes {
    volume_name    = docker_volume.nginx_volume.name
    container_path = "/usr/share/nginx/html"
    read_only      = true
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.index_html.rendered}' > index.html"
    working_dir = "${path.module}"
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
