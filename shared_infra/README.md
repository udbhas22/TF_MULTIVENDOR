# ACFW 2.0 - Terraform Infrastructure Deployment

This project automates the provisioning of a cloud-based infrastructure for the **ACFW 2.0** environment using Terraform. It sets up a secure and scalable VPC environment in the **AWS Mumbai (ap-south-1)** region, including:

- VPC and subnets
- Internet Gateway and Route Tables
- Security Group with RDP and SSH access
- Network Interfaces (ENIs)
- EC2 instances for Jump Server and CyPerf Server

---

## 📁 Project Structure

```
terraform_acfw_2.0_refactored/
│
├── shared_infra/
│   ├── main.tf                # Core infrastructure definitions
│   ├── variables.tf           # Variable declarations
│   ├── terraform.tfvars       # Values for declared variables
│   ├── modules/               # Reusable modules
│   │   ├── vpc/
│   │   ├── subnet/
│   │   ├── internet_gateway/
│   │   ├── route_table/
│   │   ├── security_group/
│   │   ├── eni/
│   │   └── ec2_instance/
```

---

## 🚀 What It Deploys

### VPC and Subnets
- A primary VPC with CIDR `172.16.0.0/16`
- Subnets:
  - **Public**: `172.16.5.0/24`
  - **Management**: `172.16.10.0/24`
  - **CyPerf**: `172.16.3.0/24`

### Network Infrastructure
- Internet Gateway (attached to VPC)
- Public Route Table (0.0.0.0/0) associated with public & management subnets

### Security Group
- Allows:
  - **SSH** (TCP 22) from anywhere
  - **RDP** (TCP 3389) from anywhere

### ENIs (Elastic Network Interfaces)
- Jump Server Management ENI
- CyPerf Server Management ENI
- CyPerf Server CyPerf ENI

### EC2 Instances
- **Jump Server**: Public + Management ENI, public IP attached
- **CyPerf Server**: Management + CyPerf ENI, no public IP

---

## 🛠 How to Use

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan Infrastructure
```bash
terraform plan
```

### 3. Apply Infrastructure
```bash
terraform apply
```

You can also auto-approve the plan:
```bash
terraform apply -auto-approve
```

### 4. Destroy Infrastructure
```bash
terraform destroy
```

Or with auto-approve:
```bash
terraform destroy -auto-approve
```

---

## 🔧 Input Variables

Defined in `variables.tf`, populated via `terraform.tfvars`.

| Variable              | Description                          | Type     | Example                        |
|-----------------------|--------------------------------------|----------|--------------------------------|
| `region`              | AWS region                           | string   | `"ap-south-1"`                 |
| `common_tags`         | Tags for all resources               | map      | `{ Project = "...", ... }`     |
| `subnets`             | Subnet configurations                | map      | See `terraform.tfvars`         |
| `shared_enis`         | ENIs used by shared instances        | map      | See `terraform.tfvars`         |
| `shared_instances`    | EC2 instance configurations          | map      | See `terraform.tfvars`         |

---

## 📦 Outputs

| Output             | Description                     |
|--------------------|---------------------------------|
| `vpc_id`           | ID of the created VPC           |
| `subnet_ids`       | Map of subnet names to IDs      |
| `security_group_id`| Security group ID               |

---

## 🧩 Module Descriptions

| Module             | Purpose                        |
|--------------------|--------------------------------|
| `vpc`              | Creates VPC                    |
| `subnet`           | Creates subnets per config     |
| `internet_gateway` | Attaches IGW to the VPC        |
| `route_table`      | Creates and associates routes  |
| `security_group`   | Defines ingress security rules |
| `eni`              | Creates ENIs with IPs and tags |
| `ec2_instance`     | Launches EC2s with ENIs        |

---

## 📝 Notes

- Ensure your `terraform.tfvars` has valid subnet CIDRs and private IPs aligned with the subnet ranges.
- All AMIs must be available in the `ap-south-1` region.
- Key pairs (`ACFW2.0-ACCESS-Key`) must already exist in your AWS account.

---

## 👤 Maintainer

**Udbhas (UD)**  
Cloud & Infra Engineer | Terraform Enthusiast | [LinkedIn](https://www.linkedin.com/in/)

---

## 📄 License

MIT License – free to use, modify, and share.