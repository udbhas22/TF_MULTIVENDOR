# Cisco Infrastructure (ACFW-2.0) - Terraform Deployment

This Terraform configuration provisions the Cisco infrastructure in AWS. It references the `shared_infra` state for VPC, subnets, and security groups, and deploys:

- Cisco virtual machines (with management and private interfaces)
- A Cisco firewall with multiple ENIs
- Custom private subnet

---

## 📁 Structure

```
cisco_infra/
├── main.tf
├── variables.tf
├── versions.tf
└── cisco_infra.tfvars
```

---

## 📦 Modules Used

- `../modules/eni`: For network interfaces (ENIs)
- `../modules/ec2_instance`: For EC2 instance deployment
- `../modules/firewall_instance`: For firewall deployment

---

## 🔗 Remote Backend

Uses S3 for state storage:

```hcl
terraform {
  backend "s3" {
    bucket = "multivendor-project-terraform-state-20250607"
    key    = "udtest/cisco/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

And consumes remote state from the shared infrastructure:

```hcl
data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket = "multivendor-project-terraform-state-20250607"
    key    = "udtest/shared/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

---

## 🧩 Variables

### `common_tags`

A map of common tags applied to all resources.

### `cisco_instances`

Map of Cisco VM instances. Each instance includes:

- `ami`: AMI ID
- `instance_type`: EC2 type
- `subnet_key`: Logical subnet name (e.g. `management_subnet_id`)
- `key_name`: SSH key name
- `management_ip`: Management IP address
- `private_ip`: Private IP address
- `private_subnet_id_key`: Static string (typically `cisco_private_subnet_id`)

### `cisco_firewall`

Describes the Cisco firewall instance and its network interfaces:

- `ami`
- `instance_type`
- `key_name`
- `associate_public_ip_address`
- `name`
- `network_interfaces`: List of objects with `private_ip`, `name`, and `subnet_key`

---

## 🌐 Subnets

### Private Subnet

One custom subnet is created:

```hcl
resource "aws_subnet" "cisco_private_subnet" {
  cidr_block = "172.16.101.0/24"
}
```

All other subnets (e.g. `management`, `cyperf`, `public`) are sourced from shared infra state.

---

## 🏗️ Resources Deployed

- Management ENIs and private ENIs for all VMs
- Cisco EC2 instances (with 2 ENIs each)
- Firewall ENIs (Management, Cyperf, Public, Private)
- One Cisco firewall instance with 4 attached ENIs

---

## 🚀 Usage

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Plan the Deployment**
   ```bash
   terraform plan -var-file="cisco_infra.tfvars"
   ```

3. **Apply**
   ```bash
   terraform apply -auto-approve -var-file="cisco_infra.tfvars"
   ```

4. **Destroy**
   ```bash
   terraform destroy -auto-approve -var-file="cisco_infra.tfvars"
   ```

---

## 📝 Notes

- Make sure to create/maintain the `shared_infra` backend prior to this.
- Match subnet keys (like `management`, `cyperf`, etc.) with shared output structure.
- Use `replace(..., "_subnet_id", "")` to match naming conventions dynamically.

---

## 👨‍💻 Author

This infrastructure is maintained by the DevOps/Cloud team for the ACFW-2.0 multivendor automation project.
