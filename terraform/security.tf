resource "aws_security_group" "allow_ssh_netbird" {
    name = "k3s-sg"
    description = "Securoty group for K3s node"
    vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.allow_ssh_netbird.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    description = "SSH"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_netbird" {
    security_group_id = aws_security_group.allow_ssh_netbird.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 51820
    to_port = 51820
    ip_protocol = "udp"
    description = "Netbird Agent"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
    security_group_id = aws_security_group.allow_ssh_netbird.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
    description = "Allow ALL"
}
