

resource "aws_instance" "aws-instance-name" {
  for_each                    = toset(var.instances)
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "${var.ws_id}-keypair"

  tags = {
    Name        = "${each.key}-${var.ws_id}-${var.lab_index}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_route53_record" "dns" {
  for_each = aws_instance.aws-instance-name
  zone_id  = var.zoneid
  name     = "${each.key}-${var.ws_id}-${var.lab_index}"
  type     = "A"
  ttl      = 60
  #  records  = [element(aws_instance.${each.key}.public_ip)]
  records = [aws_instance.aws-instance-name[each.key].public_ip]
}
