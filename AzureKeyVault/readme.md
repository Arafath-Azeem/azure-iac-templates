# Azure Key Vault – Private Access Only (Public Network Disabled)

## Overview
This module deploys an **Azure Key Vault (AKV)** with **Public Network Access disabled**, ensuring that secrets, keys, and certificates are accessible **only through private network paths**.

This configuration is intended for **high-security and production environments**, aligning with **Zero Trust**, **least privilege**, and **defense-in-depth** principles.

---

## Key Security Characteristics
- ✅ Public network access **disabled**
- ✅ Network ACLs deny all public traffic
- ✅ Designed for **private endpoint–only access**
- ✅ No hard-coded secrets or credentials
- ✅ Suitable for regulated and enterprise environments

---

## What This Deployment Creates
Depending on the implementation, the deployment may include:
- Azure Key Vault
- Public Network Access set to **Disabled**
- Network ACLs configured to deny access by default
- (Optional) Private Endpoint
- (Optional) Private DNS Zone integration
- (Optional) RBAC assignments or access policies

> Refer to the template files for exact resource definitions.

---

## Network Access Model

### ✅ Allowed
- Traffic through **Private Endpoints**
- Access from approved VNets
- Azure services **only if explicitly enabled**

### ❌ Blocked
- Public internet access
- Access from untrusted or unknown networks
- Anonymous connections

---

## Prerequisites
Before deployment, ensure:
- Azure subscription and resource group exist
- Required permissions to create:
  - Key Vault
  - Networking resources
- (If using Private Endpoint) VNet and subnet available
- Azure CLI or PowerShell installed and authenticated

---

## Deployment Options

### Option 1: Deploy using Azure CLI

#### Login and select subscription
```bash
az login
az account set --subscription <SUBSCRIPTION_ID>
```
---

```bash
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file main.bicep \
  --parameters @parameters.json
```
This deploys the Key Vault with public network access disabled based on the template configuration.

### Option 2:  Deploy using Powershell

#### Login and select subscription
```powershell
Connect-AzAccount
Set-AzContext -SubscriptionId "<SUBSCRIPTION_ID
```

---

```powershell

New-AzResourceGroupDeployment `
  -ResourceGroupName "<RESOURCE_GROUP_NAME>" `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile "parameters.json
```
Deployment will enforce private-only access as defined in the template.

