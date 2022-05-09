variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}

output "public_ip" {
    value       = aws_instance.example.public_ip
    description = "The public IP address of the web server"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami           = "ami-0e449176cecc3e577"
    instance_type = "a1.medium"
    key_name      = "aws_key"
    vpc_security_group_ids = [aws_security_group.instance.id]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("aws_key")
      timeout     = "4m"
    }
   
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install httpd
                service httpd start
                EOF

    tags = {
        Name = "terraform-ec2-example w-ssh"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
} 

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvlkzsG5aw7iTMPqnfJfuYASHSxpuBGduBp/nWMxmFCMavfOanVRzbGoAPkOk2U+UyBjQZfafXPQBjrw/rKTJ5ZCid9pKKeR67/Wjhy38wMT0yb02y/3j5XKaO0YKLWxvu8oLUuImz77Aq6x3RwWQzDV420cTocbG4d4t2By9RuRz/9w5hm8kY4we/VN3LCaaDbTqqkZcQ/wqtAsMdv6zxGXFOaekkTvVnhWJFxQZSoxC/SlcU2Z5assoxTp2yoqKxdzFQunGW7fj7KqUHO7y9zGaZJe3fe/SCtroC4vINapYwxTFdPU06daDnyeqbEHTCOzIKesPJ8z+qi54lZ5WF Frank@Frank-PC"
}