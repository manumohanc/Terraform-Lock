resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
 
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "aws_security_group" "Frontend-traffic" {

  name_prefix = "${var.project}-${var.environment}-frontend-"
  description = "Allow HTTP traffic over port 80,443 "
 
  ingress {
    description      = "HTTPD traffic over port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Https traffic over port 443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {

    "Name" = "${var.project}-${var.environment}-frontend"
  }

  lifecycle {
    create_before_destroy = true
  }

}
