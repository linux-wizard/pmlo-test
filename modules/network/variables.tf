variable "container_port" {
  type        = number
  default     = 8081
  description = "Container port"
}

variable "container_name" {
  type        = string
  default     = "test-app"
  description = "Container application name"
}