# 🏗️ Production-Grade AWS ECS Fargate & ALB Container Deployment

![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20ECR%20%7C%20ALB-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerized-blue?style=for-the-badge&logo=docker&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Application-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Security](https://img.shields.io/badge/Security-DevSecOps-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

An enterprise-ready **Container Orchestration & Infrastructure Deployment** project leveraging **AWS ECS Fargate (Serverless Compute)**, **Elastic Container Registry (ECR)**, and **Application Load Balancer (ALB)** to host scalable, high-availability web services.

The architecture decouples traffic management from application containers using strict Security Group isolation, automated target health checks, and public-facing Load Balancers.

---

## 🛠️ Technologies & Tech Stack Used

* **Cloud Provider:** Amazon Web Services (AWS)
* **Container Orchestration:** AWS ECS (Elastic Container Service - Fargate Serverless)
* **Container Registry:** AWS ECR (Elastic Container Registry)
* **Traffic & Load Balancing:** Application Load Balancer (ALB) & Target Groups (`ecs-tg`)
* **Security & Networking:** AWS Security Groups (`alb-sg` ➔ `ecs-task-sg` Chaining)
* **Containerization:** Docker & Dockerfile
* **Backend Runtime:** Node.js & Express.js
* **Version Control:** Git & GitHub

---

## 🌐 Live Infrastructure Endpoint & ALB DNS

| Deployment Attribute | Configuration & Runtime Metadata |
| :--- | :--- |
| **Live Application Endpoint** | http://localhost |
| **AWS Cloud Region** | `ap-south-1` (Mumbai) |
| **Orchestration Engine** | AWS ECS Fargate (Serverless Containers) |
| **Container Port Mapping** | Public Port 80 ➔ Container Port 3000 |
| **Container Registry** | AWS ECR (`my-first-ecr-repo`) |
| **Deployment Status** | 🟢 **ACTIVE & LIVE** |

---

## 🏛️ System Architecture Topology

```text
                        [ Public Internet ]
                                 │
                         (HTTP Traffic: Port 80)
                                 │
                                 ▼
                 ┌────────────────────────────────┐
                 │  Application Load Balancer     │
                 │         (my-app-alb)           │
                 │   Security Group: alb-sg       │
                 └───────────────┬────────────────┘
                                 │
                   (Forwarding via Target Group: ecs-tg)
                                 │
                                 ▼
                 ┌────────────────────────────────┐
                 │       AWS ECS Fargate Task     │
                 │    (Container App Port: 3000)  │
                 │  Security Group: ecs-task-sg   │
                 └────────────────────────────────┘
🧪 Live Application Verification & Testing
To verify the deployment status and operational health of the Application Load Balancer and ECS containers, execute the following CLI verification steps:

1. HTTP Response Verification via cURL
Run a cURL request to inspect the endpoint headers and confirm an HTTP 200 OK status response:

Bash
curl -I [http://my-app-alb-468651099.ap-south-1.elb.amazonaws.com](http://my-app-alb-468651099.ap-south-1.elb.amazonaws.com)
Expected Output:

Plaintext
HTTP/1.1 200 OK
Date: Mon, 31 Aug 2026 10:00:00 GMT
Content-Type: text/html; charset=utf-8
Connection: keep-alive
Server: Express / Node.js
2. End-to-End Traffic Flow & Target Health Verification
Target Group Status: Target Group ecs-tg reflects all IP targets as Healthy on container Port 3000.

ALB Ingress Handling: ALB Listener (HTTP:80) successfully receives client requests and routes them directly to the Fargate containers without port exposure risks.

⚡ Key Infrastructure Specifications
Serverless Compute: Powered by AWS ECS Fargate, eliminating the operational overhead of managing underlying EC2 instances.

Traffic Routing Isolation: Configured an Application Load Balancer (ALB) listening on public Port 80, cleanly forwarding incoming HTTP requests to target container Port 3000.

Strict Security Group Chain:

alb-sg: Permits public HTTP traffic (0.0.0.0/0) on Port 80.

ecs-task-sg: Restricts container ingress strictly to traffic originating from alb-sg on Port 3000.

Automated Health Monitoring: Real-time target health checks ensuring zero downtime and continuous routing to healthy container tasks.

📁 Repository Organization
Plaintext
.
├── Dockerfile              # Docker containerization configuration & build instructions
├── app.js                  # Main Node.js application codebase / server engine
├── package.json            # Node.js dependencies and script management
├── .dockerignore           # Excludes node_modules and local build logs from image
└── README.md               # Enterprise project architecture and operational guide
🛡️ DevSecOps & Security Controls
Zero Direct Public Ingress: ECS tasks are completely isolated from direct public internet hits; entry is strictly enforced via ALB proxies.

Least-Privilege Security Policies: Firewall rules strictly bind container access back to the load balancer security group ID (alb-sg).

Registry Isolation: Docker container artifacts are authenticated, stored, and managed securely inside private AWS ECR repositories.

🚀 Execution & Operational Playbook
Prerequisites
Docker Engine: Installed and running locally.

AWS CLI v2: Configured with credentials (aws configure).

Step-by-Step Deployment Guide
1. Authenticate Docker with AWS ECR
Bash
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
2. Build & Tag Docker Image
Bash
docker build -t my-devops-image .
docker tag my-devops-image:latest <ACCOUNT_ID>[.dkr.ecr.ap-south-1.amazonaws.com/my-first-ecr-repo:latest](https://.dkr.ecr.ap-south-1.amazonaws.com/my-first-ecr-repo:latest)
3. Push Image to ECR Repository
Bash
docker push <ACCOUNT_ID>[.dkr.ecr.ap-south-1.amazonaws.com/my-first-ecr-repo:latest](https://.dkr.ecr.ap-south-1.amazonaws.com/my-first-ecr-repo:latest)
4. Deploy to AWS ECS & Configure ALB
Create an ECS Cluster and define a Task Definition for Port 3000.

Setup a Target Group (ecs-tg) targeting HTTP on Port 3000.

Deploy an Application Load Balancer (my-app-alb) with Listener Port 80 forwarding to ecs-tg.

Deploy the ECS Service with Fargate launch type.

👨‍💻 Maintainer & Author
Varla Vamsi Babu

AWS & DevOps Infrastructure Engineer

GitHub: @vamsijohn
