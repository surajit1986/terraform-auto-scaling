resource "aws_launch_template" "example" {
  name_prefix   = "example-launchconfig"
  image_id      = var.AMIS[var.AWS_REGION]
  instance_type = "t3.micro"

  key_name = aws_key_pair.mykeypair.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "example-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {

  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "example-asg"
    propagate_at_launch = true
  }
}
