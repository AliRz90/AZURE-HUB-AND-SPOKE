variable "subnet_id" {
  description = "The ID of your NIC that should be associated with the rule"
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of your NSG that should be associated with the rule"
  type        = string
}