resource "aws_lightsail_static_ip" "lightsail-static" {
  name = "static-ip_${data.local_file.client-name-file.content}"
  lifecycle {
    # Prevent the static ip from being destroyed
    prevent_destroy = true
  }
}

resource "aws_lightsail_static_ip_attachment" "lightsail-static-attach" {
  static_ip_name = aws_lightsail_static_ip.lightsail-static.id
  instance_name  = "${data.local_file.client-name-file.content}-Instance"
}