
variable "environment" {
  type        = string
  description = "The environment for deployement"
  default     = "staging"
}

variable "bucket_name" {
  type        = string
  description = "the name of the s3 bucket"
  default     = "bagidhi-prod"
}