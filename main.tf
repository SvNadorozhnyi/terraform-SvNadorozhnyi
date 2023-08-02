provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "nginx" {
  name  = "nginx-container"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
}

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
