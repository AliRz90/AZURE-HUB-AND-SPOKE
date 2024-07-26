#---------------------------
# Local declarations
#---------------------------

locals {
  gateway_ip_configuration_name  = "${var.app_gateway_name}-${var.location}-gwipc"
  frontend_port_name             = var.frontend_port == 80 ? "http-80-feport" : "https-443-feport"
  frontend_ip_configuration_name = "${var.app_gateway_name}-${var.location}-feip"
  backend_address_pool_name      = "${var.app_gateway_name}-${var.location}-beap"
  http_setting_name              = "${var.app_gateway_name}-${var.location}-be-htst"
  listener_name                  = "${var.app_gateway_name}-${var.location}-httplstn"
  request_routing_rule_name      = "${var.app_gateway_name}-${var.location}-rqrt"
  redirect_configuration_name    = "${var.app_gateway_name}-${var.location}-rdrcfg"
}

#----------------------------------------------------------
# Resource
#----------------------------------------------------------

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = true
  zones               = var.zones
  tags                = var.tags

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.gateway_ip_config_subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = var.backend_address_pool_fqdn
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = var.backend_http_settings.cookie_based_affinity
    port                                = var.backend_http_settings.port
    protocol                            = var.backend_http_settings.protocol
    probe_name                          = var.probe_config.name
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = var.Http_listener_protocol
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = var.request_routing_rule.priority
    rule_type                  = var.request_routing_rule.rule_type
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  firewall_policy_id = var.waf_policy_id

  probe {
    name                = var.probe_config.name
    protocol            = var.probe_config.protocol
    host                = var.probe_host
    path                = var.probe_config.path
    interval            = var.probe_config.interval
    timeout             = var.probe_config.timeout
    unhealthy_threshold = var.probe_config.unhealthy_threshold
  }
}