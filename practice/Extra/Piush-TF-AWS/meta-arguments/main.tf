
resource "aws_s3_bucket" "s3_bucket"{
    count = length(var.s3_list)
    bucket = var.s3_list[count.index]


}

