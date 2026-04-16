// This file creates a Log Analytics workspace module that can be used to create a new Log Analytics workspace

@description('Creates a Log Analytics workspace')
param workspaceName string 
@description('The location of the Log Analytics workspace')
param location string = resourceGroup().location
@description('The SKU of the Log Analytics workspace')
param sku string = 'PerGB2018'
@description('The retention period for the Log Analytics workspace in days')
param retentionInDays int = 30
@description('A key-value pair collection of tags')
param tags object = {}
param enableLogAccessUsingOnlyResourcePermissions bool = false

// Create a new Log Analytics workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
  }
}

// Output the Log Analytics workspace ID
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
