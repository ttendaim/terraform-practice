

data "aws_vpc" "vpc_name" {
    filter { 
    name = "tag:Name"
    values = ["default"]
    }
}


data aws_subnet "subnetid"{
    filter{
        name = "tag:Name"
        values = ["subneta"]
       
    }

    vpc_id = data.aws_vpc.vpc_name.id
}



resource aws_instance "expressions"{
    ami = "ami-004e960cde33f9146"
    instance_type = var.tags.env == "demo" ? "t2.micro": "t3.medium"
    subnet_id = data.aws_subnet.subnetid.id
    tags = var.tags
}

