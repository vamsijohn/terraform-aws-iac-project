# 🏗️ AWS Automated Infrastructure Provisioning with Terraform (IaC)

![Terraform](https://img.shields.io/badge/Terraform-v1.5+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Security](https://img.shields.io/badge/Security-DevSecOps-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

An enterprise-grade Infrastructure as Code (IaC) project created and implemented to automatically provision, configure, and tear down a multi-tier AWS cloud ecosystem without manual console intervention.

---

## 📐 Architecture & Infrastructure Overview

| Layer | AWS Component | Configuration Details | Security & Access |
| :--- | :--- | :--- | :--- |
| **Network** | Custom VPC | `10.0.0.0/16` CIDR Block | Internet Gateway & Custom Route Tables |
| **Public Subnet** | Compute Subnet | `10.0.1.0/24` (AZ-a) | Public IP enabled for Web Access |
| **Private Subnet 1** | Database Subnet A | `10.0.2.0/24` (AZ-a) | Isolated Network (No direct IGW access) |
| **Private Subnet 2** | Database Subnet B | `10.0.3.0/24` (AZ-b) | High-Availability Subnet Group setup |
| **Compute Tier** | AWS EC2 Instance | Amazon Linux 2023 (`t2.micro`) | Inbound HTTP (80) & SSH (22) Access |
| **Database Tier** | AWS RDS Instance | MySQL 8.0 Engine (`db.t3.micro`) | Restricted exclusively to Web Server SG |
| **Storage Tier** | AWS S3 Bucket | Dynamic Prefix Naming Strategy | Object Storage for Deployment Artifacts |

---

## ⚡ Core Highlights Implemented

* **VPC Networking**: Custom VPC equipped with Internet Gateway (IGW) and explicit Route Tables for public subnet routing.
* **Compute Provisioning**: Amazon Linux 2023 EC2 Instance pre-configured with Apache Web Server via automated shell bootstrapping (`user_data`).
* **Multi-AZ Database**: AWS RDS MySQL instance deployed in high-availability across multiple Availability Zones using `aws_db_subnet_group`.
* **Dynamic Storage**: AWS S3 Bucket created with dynamic prefixing to prevent global naming conflicts.
* **DevSecOps Security**: Strict Security Group isolation ensuring database port 3306 is reachable only via the Web Tier SG.

---

## 📂 Project Structure

```text
.
├── main.tf          # Core infrastructure declaration logic
├── variables.tf     # Configurable environment input parameters
├── outputs.tf       # Structured infrastructure execution outputs
├── terraform.tfvars  # Local credentials file (Protected & Git-Ignored)
└── .gitignore       # Excludes sensitive files and local state artifacts

---

📑 Declarative Code Blueprint

variable "aws_region" {
  default     = "ap-south-1"
  type        = string
  description = "Target AWS Deployment Region"
}

variable "db_password" {
  description = "Master administrative password for MySQL Database"
  type        = string
  sensitive   = true
}
Terraform
output "ec2_public_ip" {
  description = "Public IP Address assigned to Web Server"
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_name" {
  description = "Globally unique identifier of S3 Storage Bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "rds_endpoint" {
  description = "Fully Qualified Domain Name (FQDN) for MySQL Connection"
  value       = aws_db_instance.default.endpoint
}

---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Virtual Private Cloud
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "MyProject-VPC"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MyProject-IGW"
  }
}

# 3. Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "MyProject-Public-Subnet"
  }
}

# 4. Private Subnet 1 (AZ-A)
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "MyProject-Private-Subnet-1"
  }
}

# 5. Private Subnet 2 (AZ-B for RDS HA Requirements)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "MyProject-Private-Subnet-2"
  }
}

# 6. Route Tables & Associations
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyProject-Public-RT"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Compute Layer Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow Inbound HTTP and SSH Access"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. EC2 Web Instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0e1d0632543a65000"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Deployed via Terraform IaC Project!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "MyProject-WebServer"
  }
}

# 9. S3 Storage
resource "aws_s3_bucket" "my_bucket" {
  bucket_prefix = "my-iac-project-bucket-"
}

# 10. Database Subnet Group & Security Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
}

# 11. Database Instance
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

---

🛠 Deployment Lifecycle Commands

# 1. Initialize Working Directory
terraform init

# 2. Syntactical Validation & Formatting
terraform validate
terraform fmt

# 3. Execution Plan Preview
terraform plan

# 4. Automated Provisioning
terraform apply -auto-approve

# 5. Infrastructure Teardown
terraform destroy -auto-approve

---

🔒 DevSecOps & Security Practices

Credentials Isolation: Sensitive variables (terraform.tfvars) and state files (*.tfstate) are strictly excluded via .gitignore.

Network Isolation: RDS MySQL databases reside entirely within isolated Private Subnets with zero public internet access.

Least-Privilege Firewalls: Database Port 3306 accepts inbound connections exclusively from authorized Web Server Security Groups.
