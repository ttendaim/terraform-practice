

variable "file_name" {
  type    = string
  default = "files/TYDemo.txt"

}

variable "file_content_number" {
  type    = number
  default = 12263637

}

variable "file_content_bool" {
  type    = bool
  default = true
}

variable "file_content_list" {
  type    = list(string)
  default = ["Terraform", "is", "awesome"]
}

variable "file_content_set" {
  type    = set(string)
  default = ["apple", "banana", "orange"]
}

variable "file_content_map" {
  type = map(string)
  default = {
    Name    = "Terraform"
    Type    = "IaC Tool"
    Version = "1.0"
  }
}

variable "file_content_tuple" {
  default = ["Terraform", 1, true]
  type    = tuple([string, number, bool])
}

variable "file_content_object" {
  type = object({ ami = string, az = list(string) })
  default = {
    ami = "ami-0c55b159cbfafe1f0",
    az  = ["us-west-2a", "us-west-2b"]
  }
}

variable "file_name1" {
    type = string
    default = "files/TYDemo1.txt"
    description = "Name of the variable file_name"
    sensitive = true
    nullable = false
    validation {
        condition = length(var.file_name1) > 5
        error_message = "file_name must be greater than 50 characters"

    }
}
