
resource "local_file" "files-demo" {
  content  = "This is demo file created using Terraform"
  filename = var.file_name
}

resource "local_file" "file-demo-number" {
  content  = tostring(var.file_content_number)
  filename = "files/NumberDemo.txt"
}

resource "local_file" "file-demo-bool" {
  content  = tostring(var.file_content_bool)
  filename = "files/BoolDemo.txt"
}

resource "local_file" "file-demo-list" {
  content  = var.file_content_list[0]
  filename = "files/ListDemo.txt"
}


resource "local_file" "file-demo-map" {
  filename = "files/MapDemo.txt"
  content  = var.file_content_map["Name"]
}

resource "local_file" "file-demo-tuple" {
  filename = "files/TupleDemo.txt"
  content  = var.file_content_tuple[0]
}

resource "local_file" "file-demo-object" {
  filename = "files/ObjectDemo.txt"
  content  = var.file_content_object.az[0]

}

resource "local_file" "file-demo-set"{
    filename = var.file_name1
    content = "This is demo file created using Terraform with set variable type"
}