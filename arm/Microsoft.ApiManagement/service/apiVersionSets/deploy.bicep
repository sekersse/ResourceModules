@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

@description('Optional. API Version set name')
param name string = 'default'

@description('Optional. API Version set properties')
param properties object = {}

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2021-08-01' = {
  name: name
  parent: service
  properties: properties
}

@description('The resource ID of the API Version set')
output resourceId string = apiVersionSet.id

@description('The name of the API Version set')
output name string = apiVersionSet.name

@description('The resource group the API Version set was deployed into')
output resourceGroupName string = resourceGroup().name
