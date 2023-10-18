# resource "aws_volume_attachment" "ebs_attachment" {
#    device_name = "/dev/xvdf"
#    volume_id   = var.tenantVolumeID
#    instance_id = aws_instance.init_ec2.id
# }
