####################################################################################################
# Output data
output "RgName" {
  value = azurerm_resource_group.AksRg.name
}

##################################################
# Aks output
output "AksClusterName" {
  value = azurerm_kubernetes_cluster.Aks.name
}

output "AksClusterId" {
  value = azurerm_kubernetes_cluster.Aks.id
}
