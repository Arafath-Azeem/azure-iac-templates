targetScope = 'resourceGroup'

@description('Name of the Key Vault (globally unique, 3–24 characters).')
@minLength(3)
@maxLength(24)
param keyVaultName string

@description('Azure region for the Key Vault.')
param location string = resourceGroup().location

@description('SKU for Key Vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Enable Azure RBAC authorization (required / recommended for S360).')
param enableRbacAuthorization bool = true

@description('Soft-delete retention period in days (7–90).')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Enable purge protection (cannot be disabled once enabled).')
param enablePurgeProtection bool = true

@description('Tags for the Key Vault.')
param tags object = {}

var tenantId = tenant().tenantId

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: tenantId

    sku: {
      family: 'A'
      name: skuName
    }

    // ✅ S360 REQUIRED CONTROLS
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection

    // ✅ RBAC ONLY (No access policies)
    enableRbacAuthorization: enableRbacAuthorization

    // ✅ NO NETWORK ACCESS
    publicNetworkAccess: 'Disabled'

    // Required even when public access is disabled
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
