variable "hosts" {
  type = number
  default = 4
}

variable "interface" {
  type = string
  default = "ens01"
}

variable "memory" {
  type = string
  default = "4096"
}

variable "vcpu" {
  type = number
  default = 2
}

variable "vm_name" {
  type = list
  default = ["master", "worker1", "worker2", "worker3"]
}

variable "ips" {
  type = list
  default = ["192.168.122.101", "192.168.122.102", "192.168.122.103", "192.168.122.104"]
}
variable "macs" {
  type = list
  default = ["3a:b1:01:e2:6f:2d", "3a:b1:01:8f:b7:8c", "3a:b1:01:04:a9:27", "3a:b1:01:21:18:9d"]
}
