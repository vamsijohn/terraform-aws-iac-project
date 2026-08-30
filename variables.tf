variable "aws_region" {
  default     = "ap-south-1"
  type        = string
  description = "AWS Region"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}