variable "app_gateway_name" {
  description = "Name of the application gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "zones" {
  description = "Zones of the application gateway"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags of the application gateway"
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "SKU of the application gateway"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "gateway_ip_config_subnet_id" {
  description = "ID of the gateway IP configuration"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID of the public IP address"
  type        = string
}

variable "frontend_port" {
  description = "Frontend port of the application gateway"
  type        = number
}

variable "backend_address_pool_fqdn" {
  description = "FQDN of the backend address pool"
  type        = list(string)
}

variable "backend_http_settings" {
  description = "Backend HTTP settings of the application gateway"
  type = object({
    cookie_based_affinity = string
    port                  = number
    protocol              = string
  })
}

variable "Http_listener_protocol" {
  description = "Protocol of the listener"
  type        = string
}

variable "request_routing_rule" {
  description = "Request routing rule of the application gateway"
  type = object({
    priority  = number
    rule_type = string
  })
}

variable "waf_policy_id" {
  description = "ID of the WAF policy"
  type        = string
}

variable "probe_host" {
  description = "Host of the probe"
  type        = string
}

variable "probe_config" {
  description = "Probe configuration of the application gateway"
  type = object({
    name                = string
    protocol            = string
    path                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
  })
}