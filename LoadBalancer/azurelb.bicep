@description('Location of the resources')
param location string

@description('Subnet resource ID')
param subnetId string

@description('Private IP for the Load Balancer')
param lbPrivateIp string

@description('Name for the Load Balancer')
param lbName string

@description('Name for the Frontend IP Configuration')
param frontendName string

@description('Name for the Backend Address Pool')
param backendPoolName string

@description('Virtual Network resource ID')
param vnetId string

@description('Backend pool IP addresses')
param backendIpAddresses array

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendName
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: lbPrivateIp
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
        properties: {
          loadBalancerBackendAddresses: [for (ip, i) in backendIpAddresses: {
            name: 'backend-${i}'
            properties: {
              virtualNetwork: {
                id: vnetId
              }
              ipAddress: ip
            }
          }]
        }
      }
    ]
    probes: [
      {
        name: 'health-probe-443'
        properties: {
          protocol: 'Tcp'
          port: 443
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'https-rule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, backendPoolName)
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, 'health-probe-443')
          }
          protocol: 'Tcp'
          frontendPort: 443
          backendPort: 443
          idleTimeoutInMinutes: 15
          enableTcpReset: true
          enableFloatingIP: false
          loadDistribution: 'Default'
        }
      }
    ]
  }
}

output lbId string = loadBalancer.id
output frontendId string = loadBalancer.properties.frontendIPConfigurations[0].id
output backendPoolId string = loadBalancer.properties.backendAddressPools[0].id
