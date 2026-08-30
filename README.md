# 🏗️ AWS Automated Infrastructure Provisioning with Terraform (IaC)

![Terraform](https://img.shields.io/badge/Terraform-v1.5+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Security](https://img.shields.io/badge/Security-DevSecOps-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

An enterprise-grade Infrastructure as Code (IaC) project created and implemented to automatically provision, configure, and tear down a multi-tier AWS cloud ecosystem without manual console intervention.

---

## 📐 Architecture Overview

                      ┌────────────────────────────────────────────────────────┐
                      │                      AWS CLOUD                         │
                      │                                                        │
                      │  ┌──────────────────────────────────────────────────┐  │
                      │  │                  VPC (10.0.0.0/16)               │  │
                      │  │                                                  │  │
                      │  │   ┌───────────────────────────────────────────┐  │  │
                      │  │   │        Public Subnet (10.0.1.0/24)        │  │  │
                      │  │   │                                           │  │  │
Internet ──[IGW]────────┼──┼──►│   [EC2 Instance] (Apache Web Server)      │  │  │
│  │   │   • Security Group: HTTP(80), SSH(22)    │  │  │
│  │   └─────────────────────┬─────────────────────┘  │  │
│  │                         │                        │  │
│  │                         ▼                        │  │
│  │   ┌───────────────────────────────────────────┐  │  │
│  │   │  Private Subnets (10.0.2.0 & 10.0.3.0)   │  │  │
│  │   │                                           │  │  │
│  │   │   [RDS Database] (MySQL 8.0 Engine)      │  │  │
│  │   │   • Security Group: Restricted to EC2 SG  │  │  │
│  │   └───────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
│   [S3 Bucket] (Object Storage with Dynamic Prefix)     │
└────────────────────────────────────────────────────────┘


---

## ⚡ Core Components Implemented

* **VPC Networking**: Custom VPC equipped with Internet Gateway (IGW) and explicit Route Tables for public subnet routing.
* **Compute Tier**: Amazon Linux 2023 EC2 Instance pre-configured with Apache Web Server via automated shell bootstrapping (`user_data`).
* **Database Tier**: AWS RDS MySQL instance deployed in high-availability across multiple Availability Zones using `aws_db_subnet_group`.
* **Storage Tier**: AWS S3 Bucket created with dynamic prefixing to prevent global naming conflicts.
* **Network Security**: Strict Security Group isolation ensuring database accessibility is limited exclusively to web-tier instances.

---

## 📂 Project Structure

```text
.
├── main.tf          # Core infrastructure declaration logic
├── variables.tf     # Configurable environment input parameters
├── outputs.tf       # Structured infrastructure execution outputs
├── terraform.tfvars  # Local credentials file (Protected & Git-Ignored)
└── .gitignore       # Excludes sensitive files and local state artifacts



📑 Declarative Code Blueprint
Terraform
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

---

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

1.Initialize Working Directory
terraform init — Downloads and installs the HashiCorp AWS provider dependencies.

2.Syntactical Validation
terraform validate & terraform fmt — Verifies HCL syntax accuracy and enforces standard coding format conventions.

3.Spec Execution Preview
terraform plan — Generates a visual execution blueprint outlining targeted resource modifications.

4.Automated Provisioning
terraform apply — Deploys all network, compute, database, and storage assets directly into AWS.

5.Infrastructure De-provisioning
terraform destroy — Safely eliminates all created cloud infrastructure to prevent ongoing resource charges.

---

🔒 DevSecOps & Security Best Practices
1.Credentials Isolation: All sensitive credentials (terraform.tfvars) and state files (*.tfstate) are excluded from version control using strict .gitignore rules.

2.Network Segmentation: RDS MySQL databases reside entirely within isolated Private Subnets with zero public exposure.

3.Least-Privilege Security Rules: Database port 3306 accepts connections solely from authorized Web Server Security Groups.
