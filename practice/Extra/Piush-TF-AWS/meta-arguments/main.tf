
resource "aws_s3_bucket" "s3_bucket"{
    count = length(var.s3_list)
    bucket = var.s3_list[count.index]


}

resource aws_instance "new_instance" {
    ami = "ami-004e960cde33f9146"
    instance_type = "t2.micro"

    tags = var.tags

    lifecycle {
        prevent_destroy = true
        create_before_destroy = true
        ignore_changes = [
            tags
        ]
    }
}

# read replace_triggered_by