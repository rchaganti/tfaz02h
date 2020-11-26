provider local {
  #version = "~> 2.0.0"
}

locals {
  firstFile = "c:\\certs\\myFirstConfig.txt"
}

variable "filePath" {
    type = string
    default = "secondConfig.txt"
}

data "local_file" "config" {
    filename = local.firstFile
}

resource "local_file" "myFirstConfig" {
  content = data.local_file.config.content
  filename = var.filePath
}

output "newFileId" {
    value = local_file.myFirstConfig.id
}