variable "Provider" {
    default = "minikube"
}

variable "strategy" {
    default = "Recreate"
}

variable "image" {
    default = "wordpress"
}

variable "svc-type" {
    default = "LoadBalancer"
}

variable "region" {
    default = "ap-south-1"
}