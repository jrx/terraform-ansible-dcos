variable "prefix" {}
variable "admin_ip" { type = "list"}
variable "subnet_range" {}
variable "vpc_id" {}

resource "aws_security_group" "internal_bootstrap_sg" {
  name = "${var.prefix}-internal-bootstrap-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.subnet_range}"]
  }

  #NTP
  ingress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "internal_master_sg" {
  name = "${var.prefix}-internal-master-sg"
  vpc_id = "${var.vpc_id}"

# All nodes

  # Bootstrap Server Egress
  egress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ping
  ingress { from_port = -1 to_port = -1 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 0 to_port = 0 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  ingress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  egress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Master Ingress
  # Spartan
  ingress { from_port = 53 to_port = 53 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Adminrouter
  ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Secrets
  #ingress { from_port = 1337 to_port = 1337 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # ZooKeeper
  ingress { from_port = 2181 to_port = 2181 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 2888 to_port = 2888 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 3888 to_port = 3888 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Mesos Master
  ingress { from_port = 5050 to_port = 5050 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  ingress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Cockroach
  #ingress { from_port = 26257 to_port = 26257 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  #ingress { from_port = 26258 to_port = 26258 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # IAM
  #ingress { from_port = 8101 to_port = 8101 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Mesos DNS
  ingress { from_port = 8123 to_port = 8123 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 8181 to_port = 8181 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  #ingress { from_port = 7070 to_port = 7070 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Vault
  #ingress { from_port = 8200 to_port = 8200 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  ingress { from_port = 8443 to_port = 8443 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # CA
  ingress { from_port = 8888 to_port = 8888 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Metronome
  ingress { from_port = 9090 to_port = 9090 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 9443 to_port = 9443 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  ingress { from_port = 9990 to_port = 9990 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # History Service
  #ingress { from_port = 15055 to_port = 15055 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  #ingress { from_port = 15101 to_port = 15101 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Metronome
  #ingress { from_port = 15201 to_port = 15201 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  # Metrics
  ingress { from_port = 62500 to_port = 62500 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Master Egress to Agents

  egress { from_port = 5051 to_port = 5051 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61001 to_port = 61001 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61002 to_port = 61002 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 64000 to_port = 64000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  egress { from_port = 1025 to_port = 2180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 2182 to_port = 3887 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 3889 to_port = 5049 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 5052 to_port = 8079 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8082 to_port = 8180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8182 to_port = 32000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ephemeral Ports
  ingress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  #NTP
  ingress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "internal_agent_sg" {
  name = "${var.prefix}-internal-agent-sg"
  vpc_id = "${var.vpc_id}"

  # All nodes

  # Bootstrap Server Egress
  egress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ping
  ingress { from_port = -1 to_port = -1 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 0 to_port = 0 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  ingress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  egress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Master Egress
  egress {   from_port = 53   to_port = 53   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 80   to_port = 80   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 443   to_port = 443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 53   to_port = 53   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Secrets
  # egress {   from_port = 1337   to_port = 1337   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 2181   to_port = 2181   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 2888   to_port = 2888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 3888   to_port = 3888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 5050   to_port = 5050   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 8080   to_port = 8080   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Cockroach
  #egress {   from_port = 26257   to_port = 26257   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  #egress {   from_port = 26258   to_port = 26258   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # IAM
  #egress {   from_port = 8101   to_port = 8101   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Mesos DNS
  egress {   from_port = 8123   to_port = 8123   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 8181   to_port = 8181   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  #egress {   from_port = 7070   to_port = 7070   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Vault
  #egress {   from_port = 8200   to_port = 8200   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 8443   to_port = 8443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # CA
  #egress {   from_port = 8888   to_port = 8888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Metronome
  egress {   from_port = 9090   to_port = 9090   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 9443   to_port = 9443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  #egress {   from_port = 9990   to_port = 9990   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # History Service
  #egress {   from_port = 15055   to_port = 15055   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 15101   to_port = 15101   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  #Metronome
  egress {   from_port = 15201   to_port = 15201   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Metrics
  egress {   from_port = 62500   to_port = 62500   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Spartan
  egress {   from_port = 53   to_port = 53   protocol = "udp"   cidr_blocks = ["${var.subnet_range}"] }

  # Agent Ingress
  ingress { from_port = 5051 to_port = 5051 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61001 to_port = 61001 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61002 to_port = 61002 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 64000 to_port = 64000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Agent Ingress from other Agents
  ingress { from_port = 1025 to_port = 2180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 2182 to_port = 3887 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 3889 to_port = 5049 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 5052 to_port = 8079 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 8082 to_port = 8180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 8182 to_port = 32000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Agent Egress to other Agents
  egress { from_port = 1025 to_port = 2180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 2182 to_port = 3887 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 3889 to_port = 5049 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 5052 to_port = 8079 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8082 to_port = 8180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8182 to_port = 32000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ephemeral Ports
  ingress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  #NTP
  ingress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "internal_public_agent_sg" {
  name = "${var.prefix}-internal-public-agent-sg"
  vpc_id = "${var.vpc_id}"

  # All nodes

  # Bootstrap Server Egress
  egress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ping
  ingress { from_port = -1 to_port = -1 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 0 to_port = 0 protocol = "icmp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  ingress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Network Connectivity Ingress
  egress { from_port = 61003 to_port = 61003 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61420 to_port = 61420 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62080 to_port = 62080 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62501 to_port = 62501 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62502 to_port = 62502 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 61053 to_port = 61053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 62053 to_port = 62053 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 64000 to_port = 64000 protocol = "udp" cidr_blocks = ["${var.subnet_range}"] }

  # Master Egress
  egress {   from_port = 53   to_port = 53   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 80   to_port = 80   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 443   to_port = 443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 53   to_port = 53   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Secrets
  # egress {   from_port = 1337   to_port = 1337   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 2181   to_port = 2181   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 2888   to_port = 2888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 3888   to_port = 3888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 5050   to_port = 5050   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 8080   to_port = 8080   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Cockroach
  #egress {   from_port = 26257   to_port = 26257   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  #egress {   from_port = 26258   to_port = 26258   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # IAM
  #egress {   from_port = 8101   to_port = 8101   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Mesos DNS
  egress {   from_port = 8123   to_port = 8123   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 8181   to_port = 8181   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  #egress {   from_port = 7070   to_port = 7070   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Vault
  #egress {   from_port = 8200   to_port = 8200   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 8443   to_port = 8443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # CA
  #egress {   from_port = 8888   to_port = 8888   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Metronome
  egress {   from_port = 9090   to_port = 9090   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  egress {   from_port = 9443   to_port = 9443   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Packages
  #egress {   from_port = 9990   to_port = 9990   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # History Service
  #egress {   from_port = 15055   to_port = 15055   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Marathon
  egress {   from_port = 15101   to_port = 15101   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Metronome
  egress {   from_port = 15201   to_port = 15201   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Metrics
  egress {   from_port = 62500   to_port = 62500   protocol = "tcp"   cidr_blocks = ["${var.subnet_range}"] }
  # Spartan
  egress {   from_port = 53   to_port = 53   protocol = "udp"   cidr_blocks = ["${var.subnet_range}"] }

  # Agent Ingress
  ingress { from_port = 5051 to_port = 5051 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61001 to_port = 61001 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 61002 to_port = 61002 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 64000 to_port = 64000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Agent Egress to other Agents
  egress { from_port = 1025 to_port = 2180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 2182 to_port = 3887 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 3889 to_port = 5049 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 5052 to_port = 8079 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8082 to_port = 8180 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  egress { from_port = 8182 to_port = 32000 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Ephemeral Ports
  #ingress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  #egress { from_port = 32768 to_port = 60999 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  # Marathon-LB
  ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }
  ingress { from_port = 9090 to_port = 9090 protocol = "tcp" cidr_blocks = ["${var.subnet_range}"] }

  #NTP
  ingress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 123 to_port = 123 protocol = "udp" cidr_blocks = ["0.0.0.0/0"] }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "lb_masters_sg" {
  name = "${var.prefix}-lb-masters-sg"
  description = "Allow incoming traffic on Masters LB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

}

resource "aws_security_group" "lb_agents_sg" {
  name = "${var.prefix}-lb-agents-sg"
  description = "Allow incoming traffic on Public Agents LB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "admin_sg" {
  name = "${var.prefix}-admin-sg"
  description = "Allow incoming traffic from admin_ip"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  ingress {
    from_port = 8181
    to_port = 8181
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["${var.admin_ip}"]
  }

  # TODO: Define additional ports for debugging
}

output "internal_bootstrap_sg" {
  value = "${aws_security_group.internal_bootstrap_sg.id}"
}

output "internal_master_sg" {
  value = "${aws_security_group.internal_master_sg.id}"
}

output "internal_agent_sg" {
  value = "${aws_security_group.internal_agent_sg.id}"
}

output "internal_public_agent_sg" {
  value = "${aws_security_group.internal_public_agent_sg.id}"
}

output "lb_masters_sg" {
  value = "${aws_security_group.lb_masters_sg.id}"
}

output "lb_agents_sg" {
  value = "${aws_security_group.lb_agents_sg.id}"
}

output "admin_sg" {
  value = "${aws_security_group.admin_sg.id}"
}
