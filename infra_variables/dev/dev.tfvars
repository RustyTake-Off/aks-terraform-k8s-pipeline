# SSHPubKeyPath = "~/.ssh/id_rsa.pub"
Aks = {
  Suffix   = "aztfpro02"
  Location = "westeurope"
  RgName   = "rg"
  LawName  = "law"
  Tags = {
    Env = "Dev"
  }

  VnetName         = "vnet"
  VnetAddressSpace = ["10.5.0.0/16"]
  AksSubnetOneName = "aksonesubnet"
  AksSubnetOneCIDR = ["10.5.8.0/22"]
  AksSubnetTwoName = "akstwosubnet"
  AksSubnetTwoCIDR = ["10.5.12.0/22"]

  AksName = "aks"

  KubeVersion       = "1.24.6"
  DefaultNodeVMSku  = "Standard_B2s"
  AksAdminName      = "myaksadmin"
  AksHTTPAppRouting = true

  NetworkPlugin    = "azure"
  ServiceCIDR      = "10.0.100.0/22"
  DNSServiceIP     = "10.0.100.10"
  DockerBridgeCIDR = "172.17.0.1/16"
  # PodCIDR          = "10.0.112.0/22"
  # NetworkPolicy    = "calico"
}
