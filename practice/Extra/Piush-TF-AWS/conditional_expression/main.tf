

resource aws_instance "expressions"{
    ami = "ami-004e960cde33f9146"
    instance_type = var.tags.env == "demo" ? "t2micro": "t3.medium"

    tags = var.tags
}

