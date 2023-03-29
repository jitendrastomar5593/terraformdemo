variable "web-svr-location" {
  type = string
}

variable "web-svr-rg" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "web-svr-address-space" {
  type = string
}

variable "web-svr-address-prefix" {
  type = list(string)
}

variable "web-svr-name" {
  type = string
}

variable "environment" {
  type = string
}