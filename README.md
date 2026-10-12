# 🏗️ Production-Grade AWS VPC & EC2 Deployment via Terraform (IaC)

An enterprise-ready **Infrastructure as Code (IaC)** project powered by **Terraform** to design, provision, and maintain a fully customized, secure, and isolated **Virtual Private Cloud (VPC)** ecosystem on AWS.

---

## 🛠️ Toolchain & Cloud Stack (Tools Used)

**Infrastructure Automation**
![Terraform](https://shields.io)

**Cloud Infrastructure**
![AWS](https://shields.io)

**Core Linux Platform**
![Ubuntu](https://shields.io Server-22.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

**Web Engine**
![Nginx](https://shields.io)

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
```

---

## 🚀 Execution & Operational Playbook

### Prerequisites
* **Terraform CLI:** v1.0.0+ installed.
* **AWS CLI:** v2.x authenticated (`aws configure`).

### Execution Steps
1. **Clone Repository:**
   ```bash
   git clone https://github.com
   cd terraform-aws-iac-project
   ```

2. **Initialize Provider:**
   ```bash
   terraform init
   ```

3. **Apply Provisioning Target:**
   ```bash
   terraform apply -auto-approve
   ```

---

## 👨‍💻 Maintainer & Author

**Varla Vamsi Babu**  
*AWS & DevOps Infrastructure Engineer*  
* **GitHub:** [@vamsijohn](https://github.com)
