// Azure Firewall Deployment - Using Existing VNet and Subnet
targetScope = 'resourceGroup'
 
// ============================================================================
// PARAMETERS
// ============================================================================
 
@description('Azure Firewall name')
param azureFirewallName string
 
@description('Location for all resources (defaults to resource group location)')
param location string = resourceGroup().location
 
@description('Azure Firewall SKU')
@allowed(['Standard', 'Premium'])
param azureFirewallSku string
 
@description('Existing Virtual Network name')
param vnetName string

@description('Resource group of the existing VNet')
param vnetResourceGroup string = resourceGroup().name
 
@description('IP Configuration name for the firewall')
param ipConfigName string
 
@description('Public IP name for the firewall')
param publicIPName string
 
@description('Tags for all resources')
param tags object = {}
 
// ============================================================================
// VARIABLES
// ============================================================================
 
var firewallSubnetName = 'AzureFirewallSubnet'
var firewallPolicyName = '${azureFirewallName}-policy'
 
// ============================================================================
// REFERENCE EXISTING VIRTUAL NETWORK
// ============================================================================
 
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
}

// ============================================================================
// REFERENCE EXISTING SUBNET
// ============================================================================

resource firewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: vnet
  name: firewallSubnetName
}
 
// ============================================================================
// PUBLIC IP ADDRESS (Standard SKU, Static - required for Azure Firewall)
// ============================================================================
 
resource firewallPublicIP 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: publicIPName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}
 
// ============================================================================
// FIREWALL POLICY
// ============================================================================
 
resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-05-01' = {
  name: firewallPolicyName
  location: location
  tags: tags
  properties: {
    sku: {
      tier: azureFirewallSku
    }
    threatIntelMode: 'Alert'
    intrusionDetection: azureFirewallSku == 'Premium' ? {
      mode: 'Alert'
    } : null
  }
}
 
// ============================================================================
// AZURE FIREWALL
// ============================================================================
 
resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-05-01' = {
  name: azureFirewallName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: ipConfigName
        properties: {
          subnet: {
            id: firewallSubnet.id
          }
          publicIPAddress: {
            id: firewallPublicIP.id
          }
        }
      }
    ]
    threatIntelMode: 'Alert'
    sku: {
      name: 'AZFW_VNet'
      tier: azureFirewallSku
    }
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
}
 
// ============================================================================
// OUTPUTS
// ============================================================================
 
output vnetId string = vnet.id
output vnetName string = vnet.name
output firewallSubnetId string = firewallSubnet.id
output publicIPId string = firewallPublicIP.id
output publicIPName string = firewallPublicIP.name
output publicIPAddress string = firewallPublicIP.properties.ipAddress
output firewallId string = azureFirewall.id
output firewallName string = azureFirewall.name
output firewallPrivateIp string = azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
output firewallPolicyId string = firewallPolicy.id
output firewallPolicyName string = firewallPolicy.name
