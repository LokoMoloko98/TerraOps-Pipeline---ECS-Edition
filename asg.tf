data "template_file" "init" {
  template = file("${path.module}/user_data.sh")
  vars = {
  }
}

resource "aws_launch_template" "ecs_config_launch_temp" {
  name          = "${var.project_name}-${var.environment}-launch-conf"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ami_key_pair_name

  lifecycle {
    create_before_destroy = true
  }
  user_data              = data.template_file.init.rendered
  vpc_security_group_ids = [aws_security_group.wazuh_security_group.id]
  iam_instance_profile { arn = aws_iam_instance_profile.ec2_profile.arn }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type           = "gp2"
      volume_size           = "30"
      delete_on_termination = "false"
    }
  }
}

resource "aws_autoscaling_group" "bfc-asg" {
  name                      = "${var.project_name}-${var.environment}-asg"
  termination_policies      = ["OldestInstance"]
  default_cooldown          = 30
  health_check_grace_period = 30
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  launch_template {
    id      = aws_launch_template.ecs_config_launch_temp.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]
}