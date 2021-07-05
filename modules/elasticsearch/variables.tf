variable "aws_instance_es_name" {
    type        = string
    default     = "pmlo-es-${var.env}"
    description = "hostname for Elastic search Instances"
}