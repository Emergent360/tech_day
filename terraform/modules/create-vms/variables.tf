variable "lab_count" {
  type    = number
  default = 4
}

variable "instance_type" {
  type    = string
  default = "t3a.medium"
}

variable "instance_ami" {
  type    = string
  default = "ami-097104a26f5e1c26a"
}

variable "hostname_prefix" {
  type    = string
  default = "taco"
}

variable "zoneid" {
  type    = string
  default = "ZQLGJF1OAQCSD"
}

variable "ws_name" {
  type    = string
  default = "taco"
}

variable "lab_index" {
  type = number
}

variable "key_name" {
  type = string
}

variable "ws_id" {
  type = string
}

variable "instances" {
  type = list(string)
}
