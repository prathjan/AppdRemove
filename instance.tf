#get the data from the app VM WS
data "terraform_remote_state" "appvm" {
  backend = "remote"
  config = {
    organization = "Lab14"
    workspaces = {
      name = var.appvmwsname
    }
  }
}


resource "null_resource" "vm_node_init" {
  provisioner "file" {
    source = "scripts/"
    destination = "/tmp"
    connection {
      type = "ssh"
      host = "${local.appvmip}" 
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/appdremove.sh",
        "/tmp/appdremove.sh"
    ]
    connection {
      type = "ssh"
      host = "${local.appvmip}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

}

locals {
  appvmip = data.terraform_remote_state.appvm.outputs.vm_ip[0]
}

