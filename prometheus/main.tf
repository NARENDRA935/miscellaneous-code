terraform {
  backend "s3" {
    bucket = "d14-terraform"
    key    = "misc/prometheus/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos8" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = [973714476881]
}


resource "aws_instance" "prometheus" {
  ami           = data.aws_ami.centos8.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [sg-0200b43c5a335c1ba]

  tags = {
    name= "prometheus-server"
  }
}

resource "aws_route53_record" "prometheus" {
  zone_id = "Z02327421CM6HX7FT19J5"
  name    = "prometheus"
  type    = "A"
  ttl     = 30
  records = [aws_instance.prometheus.private_ip]

}