# Azure Private Load Balancer Deployment Guide

## Overview

This guide covers deploying an Azure **Internal (Private) Load Balancer** using Bicep templates via Azure Cloud Shell.

---

## Azure Load Balancer SKUs

| Feature | Basic SKU | Standard SKU |
|---------|-----------|--------------|
| Backend pool size | Up to 300 instances | Up to 1,000 instances |
| Health probes | TCP, HTTP | TCP, HTTP, HTTPS |
| Availability Zones | Not supported | Zone-redundant & zonal |
| SLA | No SLA | 99.99% SLA |
| Secure by default | Open by default | Closed to inbound flows (NSG required) |
| Multiple frontends | Not supported | Supported |
| Diagnostics | Not supported | Azure Monitor, multi-dimensional metrics |
| HA Ports | Not supported | Supported |
| Outbound rules | Not supported | Supported |
| Pricing | Free | Charged based on rules and data |

> **NOTE:** Use **Standard SKU** on  both Prod and Non-Prod 

---


## Load Balancer Components

### 1. Frontend IP Configuration
- The private IP address that receives incoming traffic
- Must be within the subnet's address range
- Can be Static or Dynamic allocation

### 2. Backend Address Pool
- Collection of VMs or VM Scale Set instances that serve requests
- VMs must be in the same virtual network

### 3. Health Probes
- Monitors backend instance health
- Supported protocols: TCP, HTTP, HTTPS
- Unhealthy instances are removed from rotation

### 4. Load Balancing Rules
- Maps frontend IP + port to backend pool + port
- Defines traffic distribution (hash-based by default)

### 5. Inbound NAT Rules (Optional)
- Port forwarding to specific backend instances
- Useful for direct RDP/SSH access

---

## Prerequisites

- Azure subscription
- Virtual Network with a subnet
- Contributor access to resource group
- Azure Cloud Shell (Bash or PowerShell)

---

## File Structure

├── main.bicep # Load Balancer template
├── main.parameters.json # Parameter values
└── README.md # This file


## Resources Created

| Resource | Description |
|----------|-------------|
| **Load Balancer** | Standard SKU internal load balancer |
| **Frontend IP** | Static private IP for receiving traffic |
| **Backend Pool** | IP-based pool with specified backend servers |
| **Health Probe** | TCP probe on port 443 |
| **Load Balancing Rule** | HTTPS rule (port 443 → 443) |

## Traffic Flow

1. Client sends request to Load Balancer's private IP (`lbPrivateIp`) on port 443
2. Health probe checks backend servers every 15 seconds on port 443
3. Load balancer distributes traffic to healthy backends using 5-tuple hash
4. Backend server responds directly to client (DSR not enabled)

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `location` | string | Azure region for deployment |
| `subnetId` | string | Resource ID of the subnet |
| `vnetId` | string | Resource ID of the virtual network |
| `lbPrivateIp` | string | Private IP for the load balancer frontend |
| `lbName` | string | Name of the load balancer |
| `frontendName` | string | Name of the frontend IP configuration |
| `backendPoolName` | string | Name of the backend address pool |
| `backendIpAddresses` | array | List of backend server IP addresses |

## Deployment Guide

# Validate the deployment using Bash

```bash
az deployment group validate \
  --resource-group <YOUR-RG-NAME> \
  --template-file main.bicep \
  --parameters main.parameters.json
```


# Deploy the Template using Bash
```bash
az deployment group create \
  --name "lb-deployment-$(date +%Y%m%d%H%M%S)" \
  --resource-group <YOUR-RG-NAME> \
  --template-file main.bicep \
  --parameters main.parameters.json \
  --verbose
  ```

# Validate the Template using PowerShell

```PowerShell
Test-AzResourceGroupDeployment `
  -ResourceGroupName <YOUR-RG-NAME> `
  -TemplateFile main.bicep `
  -TemplateParameterFile main.parameters.json
  ```

# Deploy the Template using PowerShell

```PowerShell
New-AzResourceGroupDeployment `
  -Name "lb-deployment-$(Get-Date -Format 'yyyyMMddHHmmss')" `
  -ResourceGroupName <YOUR-RG-NAME> `
  -TemplateFile main.bicep `
  -TemplateParameterFile main.parameters.json `
  -Verbose
  ```


## References

| Topic | Link |
|-------|------|
| Azure Load Balancer Overview | https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview |
| Load Balancer SKU Comparison | https://learn.microsoft.com/en-us/azure/load-balancer/skus |
| Internal Load Balancer | https://learn.microsoft.com/en-us/azure/load-balancer/components#frontend-ip-configurations |
| Health Probes | https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview |
| Load Balancing Rules | https://learn.microsoft.com/en-us/azure/load-balancer/components#load-balancing-rules |
| Backend Pools | https://learn.microsoft.com/en-us/azure/load-balancer/backend-pool-management |
| IP-based Backend Pools | https://learn.microsoft.com/en-us/azure/load-balancer/backend-pool-management#backend-pool-by-ip-address |
| Bicep Documentation | https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview |
| Bicep Load Balancer Resource | https://learn.microsoft.com/en-us/azure/templates/microsoft.network/loadbalancers |
| Azure CLI Load Balancer Commands | https://learn.microsoft.com/en-us/cli/azure/network/lb |
| PowerShell Load Balancer Cmdlets | https://learn.microsoft.com/en-us/powershell/module/az.network |
| NSG with Load Balancer | https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview#securebydefault |
| Load Balancer Troubleshooting | https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-troubleshoot |


