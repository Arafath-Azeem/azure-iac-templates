# Azure Firewall Deployment - Documentation

## Overview
This Bicep template deploys a complete Azure Firewall infrastructure including Virtual Network, Subnet, Firewall Public IP, Firewall Policy, and Azure Firewall in a hub-and-spoke network topology. 

The Secure Cloud Architecture follows a **Hub-and-Spoke model** where the Azure Firewall is hosted on a hub virtual network. All spoke virtual networks are peered to the hub, and traffic between spokes is routed through the centralized firewall. **There is no direct spoke-to-spoke communication** - all inter-spoke traffic must traverse the hub firewall, ensuring centralized security control, traffic inspection, and policy enforcement across the entire network topology.

---

## Files

- `azfw.bicep` - Main Infrastructure-as-Code template that deploys all Azure Firewall components
- `azfw.parameters.json` - Parameter file containing configuration values for the deployment.
- `README.md` - Over of this documentation and how-to-use guide

---
## Prerequisite 

Create a Virtual Network (VNET) and a dedicated Subnet for Firewall

[Learn More about IP pools](https://learn.microsoft.com/en-us/azure/virtual-network-manager/how-to-manage-ip-addresses-network-manager?tabs=armtemplate)

## What Gets Deployed ?

### Resources Created

| Resource Type | Name | Purpose |
|--------------|------|---------|
| **Public IP** | `azseafwpibip` | Static Standard SKU public IP for firewall |
| **Firewall Policy** | `azseazfw01-policy` | Premium tier policy with IDPS in Alert mode |
| **Azure Firewall** | `azseazfw01` | Premium SKU firewall with advanced security features |

---

## Component Details

### 1. Public IP Address
- **SKU**: Standard (required for Azure Firewall)
- **Allocation**: Static (IP persists even when firewall is stopped)
- **Version**: IPv4
- **Assigned IP**: Automatically allocated by Azure (e.g., 4.193.207.146)

### 2. Firewall Policy
- **Tier**: Premium
- **Threat Intelligence Mode**: Alert (logs threats but doesn't block)
- **IDPS Mode**: Alert (signature-based intrusion detection)
- **TLS Inspection**: Disabled (no certificate authority configured)
- **Rules**: None configured (empty policy ready for customization)

### 3. Azure Firewall
- **SKU**: Premium
- **Features Enabled**:
  - ✅ Threat Intelligence (Alert mode)
  - ✅ IDPS (Alert mode)
  - ✅ Advanced URL filtering capability
  - ✅ Web categories support
  - ❌ TLS Inspection (disabled)
- **Performance**: Up to 100 Gbps throughput
- **IP Configuration**: Custom named configuration for public IP assignment

---

## Parameters Explained

### Required Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `azureFirewallName` | `azseazfw01` | Name of the Azure Firewall resource |
| `azureFirewallSku` | `Premium` | Firewall tier (Standard or Premium) |
| `vnetName` | `az-sea-ppe-ame-azfw-hub-vnet01` | Virtual network name |
| `vnetAddressPrefix` | `172.16.9.0/26` | VNet IP address range |
| `firewallSubnetAddressPrefix` | `172.16.9.0/26` | Firewall subnet range (min /26) |
| `publicIPName` | `azseafwpibip` | Public IP resource name |
| `ipConfigName` | `azseafwpibip` | IP configuration display name |

### Optional Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `location` | Resource Group location | Azure region for deployment |
| `tags` | Environment: NonProd | Resource tags for organization |

---

## Deployment Process

### Pre-requisites
- Azure subscription
- Resource group created: `az-sea-ppe-ame-azfw-hub-rg`
- Azure CLI or Cloud Shell access
- Bicep CLI installed (if deploying locally)

### Deployment Steps

**Create Resource Group**
```bash
az group create \
--name "az-sea-ppe-ame-azfw-hub-rg" \
--location "southeastasia"
```

## Validating the Templates before deployment 

The az deployment group validate command checks your Bicep template for errors without deploying any resources. It's a safety check that catches problems before you commit to an actual deployment.

**What It Validates ?**

- Template Syntax - Verifies Bicep code is properly formatted and all resource definitions are valid

- Parameters - Ensures all required parameters have values and types match (e.g., Premium/Standard for SKU, valid CIDR notation for IP ranges)

- Resource Constraints - Checks that SKUs are available in your target region, subnet sizes meet minimums (Azure Firewall needs minimum /26), and configurations are valid

- Azure Policy Compliance - Validates the deployment doesn't violate any Azure Policies in your subscription

- Dependencies - Verifies resource references and dependencies are correctly defined

**What It Doesn't Do ?**

- ❌ Deploy resources - Nothing gets created
- ❌ Check quotas - Won't catch subscription limits
- ❌ Estimate costs - No pricing validation
- ❌ Test connectivity - Can't verify networks will actually work

**Example Output**
Success: Returns "provisioningState": "Succeeded" with 

### Validate the template before deployment (Bash) 
```bash
az deployment group validate \
  --resource-group "YOUR-RESOURCE-GROUP" \
  --template-file azfw.bicep \
  --parameters azfw.parameters.json
  ```

### Validate the template before deployment (PowerShell) 
```Powershell
az deployment group validate `
  --resource-group "YOUR-RESOURCE-GROUP" `
  --template-file azfw.bicep `
  --parameters azfw.parameters.json
  ```

## Deploy the Azure Firewall Template through Cloud Shell (Bash)
```bash
az deployment group create \
  --name "azfw-deployment-$(date +%Y%m%d%H%M%S)" \
  --resource-group "YOUR-RESOURCE-GROUP" \
  --template-file azfw.bicep \
  --parameters azfw.parameters.json
  ```

## Deploy the Azure Firewall Template through Cloud Shell (PowerShell)

```Powershell
az deployment group create `
  --name "azfw-deployment-$(Get-Date -Format 'yyyyMMddHHmmss')" `
  --resource-group "YOUR-RESOURCE-GROUP" `
  --template-file azfw.bicep `
  --parameters azfw.parameters.json
```
