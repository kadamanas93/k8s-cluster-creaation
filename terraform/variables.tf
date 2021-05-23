variable "namespace" {
  type    = string
  default = "create"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "name" {
  type    = string
  default = "k8s"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}