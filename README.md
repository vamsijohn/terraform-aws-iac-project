# 🏗️ Production-Grade AWS VPC & EC2 Deployment via Terraform (IaC)

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Web%20Server-009639?style=for-the-badge&logo=nginx&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

An enterprise-ready **Infrastructure as Code (IaC)** project powered by **Terraform** to design, provision, and maintain a fully customized, secure, and isolated **Virtual Private Cloud (VPC)** ecosystem on AWS.

The pipeline automatically provisions network topologies (Subnets, Route Tables, Internet Gateways), configures stateful firewall security policies, and bootstraps a dynamic **Nginx Web Server** on a compute node upon execution.

---

## 🌐 Live Infrastructure Endpoint & Public IP

| Deployment Attribute | Configuration & Runtime Metadata |
| :--- | :--- |
| **Server Public IP Address** | `44.220.190.225` |
| **Live Application Endpoint** | [http://44.220.190.225](http://44.220.190.225) |
| **AWS Cloud Region** | `us-east-1` (N. Virginia) |
| **Compute Stack** | Ubuntu Server 22.04 LTS (`amd64`) |
| **Web Service Engine**| Nginx HTTP Server (Port 80) |
| **Deployment Status** | 🟢 **ACTIVE & LIVE** |

---

## 🏛️ System Architecture Topology

```text
                        [ AWS Cloud (us-east-1) ]
                                   │
                           ┌───────┴───────┐
                           │   Custom VPC  │
                           │  10.0.0.0/16  │
                           └───────┬───────┘
                                   │
                         [ Internet Gateway ]
                                   │
                       ┌───────────┴───────────┐
                       │ Custom Route Table    │ (0.0.0.0/0)
                       └───────────┬───────────┘
                                   │
                        ┌──────────┴──────────┐
                        │    Public Subnet    │
                        │     10.0.1.0/24     │
                        └──────────┬──────────┘
                                   │
                      ┌────────────┴────────────┐
                      │  Security Group (SG)   │
                      │ Inbound: HTTP(80), SSH │
                      └────────────┬────────────┘
                                   │
                      ┌────────────┴────────────┐
                      │   EC2 Compute Instance  │
                      │  IP: 44.220.190.225     │
                      │  (Ubuntu 22.04 + Nginx) │
                      └─────────────────────────┘

⚡ Key Infrastructure Specifications

Isolated Custom Network: Built with custom VPC segmentation (10.0.0.0/16) away from default AWS networks.

Auto-Routing Infrastructure: Internet Gateway (IGW) attached with route table associations for seamless outbound communication.

Dynamic Public IP Output: Outputs runtime IP 44.220.190.225 directly via outputs.tf for deployment verification.

Dynamic AMI Sourcing: Uses dynamic HCL data queries (data.aws_ami.ubuntu) to automatically pull the newest Canonical LTS image containing the latest kernel security patches.

Automated Bootstrapping: Zero-touch web server installation using advanced Shell scripts passed into EC2 user_data.

Modular Code Structure: Standardized separation of concerns using decoupled main.tf, variables.tf, and outputs.tf configs.

📁 Repository Organization

Plaintext
.
├── main.tf              # Primary HCL resources (VPC, Subnets, IGW, Route Tables, SG, EC2)
├── variables.tf         # Declarative variable definitions and strict type constraints
├── outputs.tf           # Exported runtime parameters (EC2 Public IP address, IDs)
├── terraform.tfvars     # Local environment runtime variable overrides (Git-ignored)
├── .gitignore           # Prevents committing .tfstate, provider caches, and secrets
└── README.md            # Enterprise project architecture and operational guide

🛡️ DevSecOps & Security Controls

State Isolation: .tfstate and .tfstate.backup files are strictly excluded from source control to avoid state drift issues and credential exposure.

Network Perimeter Security: Ingress security group policies enforce strict port isolation—blocking all non-essential application protocols.

Secret Hygiene: Zero hardcoded credential policies followed; AWS authentication managed cleanly through environment variables or AWS CLI setup.

🚀 Execution & Operational Playbook

Prerequisites
Terraform CLI: v1.0.0+ installed.

AWS CLI: v2.x authenticated (aws configure).

Step-by-Step Deployment Guide
Clone the Repository:

Bash
git clone [https://github.com/vamsijohn/terraform-aws-iac-project.git](https://github.com/vamsijohn/terraform-aws-iac-project.git)
cd terraform-aws-iac-project
Initialize Terraform Modules & Providers:

Bash
terraform init
Validate Code Formats & Syntax:

Bash
terraform validate
Generate Execution Dry-Run Plan:

Bash
terraform plan
Apply Provisioning Target:

Bash
terraform apply -auto-approve
Tear Down Infrastructure (Post-Testing):

Bash
terraform destroy -auto-approve

👨‍💻 Maintainer & Author

Varla Vamsi Babu
AWS & DevOps Infrastructure Engineer
GitHub: @vamsijohn
