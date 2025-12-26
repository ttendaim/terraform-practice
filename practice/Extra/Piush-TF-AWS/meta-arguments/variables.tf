
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

variable "s3_buc" {
  type = set(string)
  description = "testing"
  default = ["bucket-1234-2625","bucket-1234-2725"]
}

variable "s3_list" {
  type  = list(string)
  default = ["baghidhi-2525","baghidhi-2526"]
}