@description('Required. The name of the encryptionProtector')
param name string = 'current'

@description('Required. Name of the SQL managed instance.')
param managedInstanceName string

@description('Required. The name of the SQL managed instance key.')
param serverKeyName string

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. Key auto rotation opt-in flag')
param autoRotationEnabled bool = false

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName
}

resource encryptionProtector 'Microsoft.Sql/managedInstances/encryptionProtector@2021-05-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
    serverKeyType: serverKeyType
  }
}

@description('The name of the deployed managed instance')
output name string = encryptionProtector.name

@description('The resource ID of the deployed managed instance')
output resourceId string = encryptionProtector.id

@description('The resource group of the deployed managed instance')
output resourceGroupName string = resourceGroup().name
