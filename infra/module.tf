####################################################################################################
# Creating base resource
resource "azurerm_resource_group" "AksRg" {

  name     = "${var.Aks.RgName}${var.Aks.Suffix}"
  location = var.Aks.Location
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })
}

####################################################################################################
# Network resources configuration
resource "azurerm_virtual_network" "Vnet" {

  name                = "${var.Aks.VnetName}${var.Aks.Suffix}"
  location            = azurerm_resource_group.AksRg.location
  resource_group_name = azurerm_resource_group.AksRg.name
  address_space       = var.Aks.VnetAddressSpace
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })
}

resource "azurerm_subnet" "AksSubnetOne" {

  name                 = var.Aks.AksSubnetOneName
  resource_group_name  = azurerm_resource_group.AksRg.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = var.Aks.AksSubnetOneCIDR
}

resource "azurerm_subnet" "AksSubnetTwo" {

  name                 = var.Aks.AksSubnetTwoName
  resource_group_name  = azurerm_resource_group.AksRg.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = var.Aks.AksSubnetTwoCIDR
}

####################################################################################################
# Log analytics resources configuration
resource "azurerm_log_analytics_workspace" "Law" {

  name                = "${var.Aks.LawName}${var.Aks.Suffix}"
  location            = azurerm_resource_group.AksRg.location
  resource_group_name = azurerm_resource_group.AksRg.name
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })
}

resource "azurerm_log_analytics_solution" "LawContainerSolution" {

  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.AksRg.location
  resource_group_name   = azurerm_resource_group.AksRg.name
  workspace_resource_id = azurerm_log_analytics_workspace.Law.id
  workspace_name        = azurerm_log_analytics_workspace.Law.name
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

####################################################################################################
# Creating a user identity and assigning roles to it
resource "azurerm_user_assigned_identity" "AksUserIdentity" {

  name                = "${var.Aks.AksName}identity"
  location            = azurerm_resource_group.AksRg.location
  resource_group_name = azurerm_resource_group.AksRg.name
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })
}

resource "azurerm_role_assignment" "AksRgContributorRole" {

  principal_id                     = azurerm_user_assigned_identity.AksUserIdentity.principal_id
  role_definition_name             = "Contributor"
  scope                            = azurerm_resource_group.AksRg.id
  skip_service_principal_aad_check = true
}

data "azurerm_resource_group" "AksNodeRg" {

  name = azurerm_kubernetes_cluster.Aks.node_resource_group
}

resource "azurerm_role_assignment" "VirtualMachineContributorRole" {

  principal_id                     = azurerm_user_assigned_identity.AksUserIdentity.principal_id
  role_definition_name             = "Virtual Machine Contributor"
  scope                            = data.azurerm_resource_group.AksNodeRg.id
  skip_service_principal_aad_check = true
}


####################################################################################################
# Aks resource configuration
resource "azurerm_kubernetes_cluster" "Aks" {

  name                = lower("${var.Aks.AksName}${var.Aks.Suffix}")
  location            = azurerm_resource_group.AksRg.location
  resource_group_name = azurerm_resource_group.AksRg.name
  tags = merge(var.Aks.Tags,
    {
      Project = "aztfpro05"
      MadeBy  = "RustyTake-Off"
  })

  dns_prefix                       = lower("dns${var.Aks.AksName}${var.Aks.Suffix}")
  kubernetes_version               = var.Aks.KubeVersion
  automatic_channel_upgrade        = "patch"
  sku_tier                         = "Free"
  node_resource_group              = lower("mc-${var.Aks.RgName}-${var.Aks.Location}-${var.Aks.AksName}-${var.Aks.Suffix}")
  http_application_routing_enabled = var.Aks.AksHTTPAppRouting

  default_node_pool {
    name                = "system"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
    max_pods            = 100
    vm_size             = var.Aks.DefaultNodeVMSku
    os_disk_size_gb     = 50
    os_sku              = "Ubuntu"
    vnet_subnet_id      = azurerm_subnet.AksSubnetOne.id
    scale_down_mode     = "Delete"
    type                = "VirtualMachineScaleSets"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.AksUserIdentity.id]
  }

  network_profile {
    network_plugin     = try(var.Aks.NetworkPlugin, "kubelet")
    service_cidr       = try(var.Aks.ServiceCIDR, null)
    dns_service_ip     = try(var.Aks.DNSServiceIP, null)
    docker_bridge_cidr = try(var.Aks.DockerBridgeCIDR, null)
    pod_cidr           = try(var.Aks.PodCIDR, null)
    network_policy     = try(var.Aks.NetworkPolicy, null)
  }

  linux_profile {
    admin_username = var.Aks.AksAdminName

    ssh_key {
      key_data = file(var.SSHPubKeyPath)
    }
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.Law.id
  }
}
