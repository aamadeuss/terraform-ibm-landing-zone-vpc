########################################################################################################################
# Input variables
########################################################################################################################

#
# Module developer tips:
#   - Examples are references that consumers can use to see how the module can be consumed. They are not designed to be
#     flexible re-usable solutions for general consumption, so do not expose any more variables here and instead hard
#     code things in the example main.tf with code comments explaining the different configurations.
#   - For the same reason as above, do not add default values to the example inputs.
#

variable "apiKey" {
  type        = string
  description = "The IBM Cloud API Key."
  sensitive   = true
}

variable "reg" {
  type        = string
  description = "Region to provision all resources created by this example."
}

variable "pfx" {
  type        = string
  description = "A string value to prefix to all resources created by this example."
}

variable "rg" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable."
  default     = null
}

variable "resTags" {
  type        = list(string)
  description = "List of resource tag to associate with all resource instances created by this example."
  default     = []
}

variable "tags_access" {
  type        = list(string)
  description = "Optional list of access management tags to add to resources that are created."
  default     = []
}
