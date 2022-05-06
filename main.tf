provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami           = "ami-09d56f8956ab235b3"
    instance_type = "t2.micro"

    tags = {
        Name = "terraform-ec2-example"
    }
}