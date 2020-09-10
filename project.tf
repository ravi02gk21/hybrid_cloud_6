provider "kubernetes" {
    config_context_cluster = var.Provider
}

resource "kubernetes_deployment" "wp-deploy" {
    metadata {
        name = "wp"
        labels = {
            App = "wordpress"
        }
    }
    spec {
        selector {
            match_labels = {
                App = "wordpress"
                tier = "frontend"
            }
        }
        strategy {
            type = var.strategy
        }
        template {
            metadata {
                labels = {
                    App = "wordpress"
                    tier = "frontend"
                }
            }
            spec {
                container {
                    image = var.image
                    name = "wordpress"
                    port {
                        container_port = 80
                    }
                }
            }
        }
        
    }
}

resource "kubernetes_service" "wp-expose" {
    metadata {
        name = "wordpress"
        labels = {
            App = "wordpress"
        }
    }
    spec {
        port {
            port = 80
            target_port = 80
        }
        selector = {
            App = "wordpress"
            tier = "frontend"
        }
    type = var.svc-type
    external_ips = ["192.168.99.105"]
    }
}


provider "aws" {
    profile = "default"
    region = var.region
}

resource "aws_db_instance" "wpdb-rds" {
  allocated_storage    = 20
  max_allocated_storage = 100
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "wordpressdb"
  name                 = "wpdb"
  username             = "root"
  password             = "roottoor"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  port                 = 3306
  auto_minor_version_upgrade = true
}

output "RDS-Instance" {
  value = aws_db_instance.wpdb-rds.address
}
