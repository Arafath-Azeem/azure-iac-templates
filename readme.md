# Azure Log Analytics Workspace Deployment

## Overview

This Bicep template deploys an Azure Log Analytics workspace that provides centralized logging and monitoring capabilities for your Azure resources. The workspace serves as a central repository for log data collection, analysis, and alerting.

## Architecture

The template creates:

- **Log Analytics Workspace**: Central logging service for collecting and analyzing telemetry data
- **Configurable Retention**: Customizable log retention period (default: 30 days)
- **Flexible Pricing**: PerGB2018 pricing tier for pay-as-you-go model
- **Resource-based Access**: Optional resource-based access control
- **Tagging Support**: Comprehensive tagging for resource organization

## Use Cases

- **Application Monitoring**: Collect and analyze application logs and metrics
- **Infrastructure Monitoring**: Monitor Azure resources and on-premises systems
- **Security Analytics**: Centralized security event collection and analysis
- **Compliance Reporting**: Maintain audit trails and compliance logs
- **Performance Monitoring**: Track resource utilization and performance metrics

## Files Included

- `LogAnalytics.bicep` - Main Bicep template for Log Analytics workspace
- `LogAnalytics.parameters.json` - Parameter values file
- `README.md` - Over of this documentation and how-to-use guide

## Prerequisites

### Azure Requirements
- **Azure Subscription** with appropriate permissions
- **Resource Group** already created or will be created during deployment

### Local Environment
- **Azure CLI** (version 2.20.0 or later) OR **Azure PowerShell** (version 5.0.0 or later)


### Permissions Required
- `Contributor` or `Log Analytics Contributor` role on the target Resource Group

## Parameters

| Parameter | Type | Description | Default Value | Allowed Values |
|-----------|------|-------------|---------------|----------------|
| `workspaceName` | string | Name of the Log Analytics workspace | `my-log-analytics-workspace` | Globally unique name |
| `location` | string | Azure region for deployment | `resourceGroup().location` | Valid Azure regions |
| `sku` | string | Pricing tier for the workspace | `PerGB2018` | `Free`, `PerNode`, `PerGB2018`, `Standalone`, `LACluster` |
| `retentionInDays` | int | Log retention period in days | `30` | 30-730 days |
| `enableLogAccessUsingOnlyResourcePermissions` | bool | Enable resource-based access control | `false` | `true`, `false` |
| `tags` | object | Resource tags for organization | `{}` | Key-value pairs |

## What must be changed in Parameters File 
- Log Analytics name 
- Tag Value of Environment set to Non-Production/Production 

# Deployment Guide

### Option 1: Azure CLI (Bash)

#### 1. Login and Set Context
```bash
# Login to Azure
az login

# Set subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify current context
az account show
```

#### 2. One-liner Deployment
```bash
az deployment group create --resource-group your-resource-groupname --template-file LogAnalytics.bicep --parameters @LogAnalytics.parameters.json
```

### Example

```bash
az deployment group create --resource-group abc-xyz-resourcegroup --template-file abcvm.bicep --parameters abcvm.paraeters.json
```

### Option 2: Azure PowerShell

#### 1. Login and Set Context
```powershell
# Login to Azure
Connect-AzAccount

# Set subscription context (if you have multiple)
Set-AzContext -SubscriptionId "your-subscription-id"

# Verify current context
Get-AzContext
```

#### 2. One-liner Deployment
```powershell
New-AzResourceGroupDeployment -ResourceGroupName your-resource-groupname  -TemplateFile LogAnalytics.bicep -TemplateParameterFile LogAnalytics.parameters.json
```

### Example

```bash
New-AzResourceGroupDeployment -ResourceGroupName abc-xyz-resourcegroup -TemplateFile WindowsVM.bicep -TemplateParameterFile WindowsVM.parameters.json
```

### Option 3: Azure Cloud Shell

#### Upload Files
1. Open [Azure Cloud Shell](https://shell.azure.com)
2. Choose PowerShell or Bash
3. Click **Upload** and select both template files

#### Deploy (PowerShell)
```powershell
New-AzResourceGroupDeployment -ResourceGroupName your-resource-groupname -TemplateFile "LogAnalytics.bicep" -TemplateParameterFile "LogAnalytics.parameters.json"
```

#### Deploy (Bash)
```bash
az deployment group create -resource-group your-resource-groupname --template-file "LogAnalytics.bicep" --parameters "@LogAnalytics.parameters.json"
```

## Post-Deployment

### Verify Deployment
```bash
# Check deployment status
az deployment group show --resource-group "rg-loganalytics-prod" --name "nameofLogAnalytics"

# Get workspace details
az monitor log-analytics workspace show \
  --resource-group "rg-loganalytics-prod" \
  --workspace-name "my-log-analytics-workspace"
```

### Get Workspace Information
```powershell
# PowerShell - Get workspace details
Get-AzOperationalInsightsWorkspace -ResourceGroupName "your-resource-groupname"
```

### Common Issues

1. **Workspace Name Already Exists**
   - Log Analytics workspace names must be globally unique
   - Try a different name or add a suffix (e.g., company name, random number)

2. **Permission Denied**
   - Verify you have `Contributor` role on the resource group
   - Check if there are any resource locks

3. **Invalid Retention Period**
   - Retention must be between 30-730 days
   - Free tier is limited to 7 days retention

4. **Region Availability**
   - Not all regions support Log Analytics
   - Check [Azure region availability](https://azure.microsoft.com/global-infrastructure/services/)


---

**Note**: Log Analytics workspace names must be globally unique across all of Azure. Consider using a naming convention that includes your organization identifier.