##############################################################################
# Module Level Variables
##############################################################################

variable "create_vpc" {
  description = "Indicates whether user wants to use an existing vpc or create a new one. Set it to true to create a new vpc"
  type        = bool
  default     = true
}

variable "existing_vpc_id" {
  description = "The ID of the existing vpc. Required if 'create_vpc' is false."
  type        = string
  default     = null
}

variable "resource_group_id" {
  description = "The resource group ID where the VPC to be created"
  type        = string
}

variable "region" {
  description = "The region to which to deploy the VPC"
  type        = string
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the VPC resources created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\". For more information, see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits."
  }
}

##############################################################################
# Naming Variables
##############################################################################

variable "prefix" {
  description = "The value that you would like to prefix to the name of the resources provisioned by this module. Explicitly set to null if you do not wish to use a prefix. This value is ignored if using one of the optional variables for explicit control over naming."
  type        = string
  default     = null
}

variable "name" {
  description = "Used for the naming of the VPC (if create_vpc is set to true), as well as in the naming for any resources created inside the VPC (unless using one of the optional variables for explicit control over naming)."
  type        = string
}

variable "dns_binding_name" {
  description = "The name to give the provisioned VPC DNS resolution binding. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

variable "dns_instance_name" {
  description = "The name to give the provisioned DNS instance. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

variable "dns_custom_resolver_name" {
  description = "The name to give the provisioned DNS custom resolver instance. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

variable "routing_table_name" {
  description = "The name to give the provisioned routing tables. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

variable "public_gateway_name" {
  description = "The name to give the provisioned VPC public gateways. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

variable "vpc_flow_logs_name" {
  description = "The name to give the provisioned VPC flow logs. If not set, the module generates a name based on the `prefix` and `name` variables."
  type        = string
  default     = null
}

##############################################################################

##############################################################################
# Optional VPC Variables
##############################################################################

variable "network_cidrs" {
  description = "List of Network CIDRs for the VPC. This is used to manage network ACL rules for cluster provisioning."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "default_network_acl_name" {
  description = "OPTIONAL - Name of the Default ACL. If null, a name will be automatically generated"
  type        = string
  default     = null
}

variable "default_security_group_name" {
  description = "OPTIONAL - Name of the Default Security Group. If null, a name will be automatically generated"
  type        = string
  default     = null
}

variable "default_routing_table_name" {
  description = "OPTIONAL - Name of the Default Routing Table. If null, a name will be automatically generated"
  type        = string
  default     = null
}

variable "address_prefixes" {
  description = "OPTIONAL - IP range that will be defined for the VPC for a certain location. Use only with manual address prefixes"
  type = object({
    zone-1 = optional(list(string))
    zone-2 = optional(list(string))
    zone-3 = optional(list(string))
  })
  default = {
    zone-1 = null
    zone-2 = null
    zone-3 = null
  }
  validation {
    error_message = "Keys for `use_public_gateways` must be in the order `zone-1`, `zone-2`, `zone-3`."
    condition = var.address_prefixes == null ? true : (
      (length(var.address_prefixes) == 1 && keys(var.address_prefixes)[0] == "zone-1") ||
      (length(var.address_prefixes) == 2 && keys(var.address_prefixes)[0] == "zone-1" && keys(var.address_prefixes)[1] == "zone-2") ||
      (length(var.address_prefixes) == 3 && keys(var.address_prefixes)[0] == "zone-1" && keys(var.address_prefixes)[1] == "zone-2") && keys(var.address_prefixes)[2] == "zone-3"
    )
  }
}

