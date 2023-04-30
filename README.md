# aks-terraform-k8s-pipeline

Remember to look around all the folders, files and change things to your own liking.

## [Projects](https://github.com/RustyTake-Off/projects)

Create an AKS cluster with Terraform and deploy K8s to it using pipelines constructed out of template files.

## Prerequisites

Azure DevOps Account

Create Azure resources:

* Resource Group

```bash
az group create --name "prrgazpro05" --location "westeurope"
```

* Azure Storage Account

```bash
az storage account create --name "prstraccazpro05" --resource-group "prrgazpro05" --location "westeurope" --sku Standard_LRS
```

* Azure Storage Account Container

```bash
az storage container create --name "prcontazpro05" --account-name "prstraccazpro05"
```

or run one of the [**prerequisites**](https://github.com/RustyTake-Off/aks-terraform-k8s-pipeline/tree/main/prerequisites) scripts.

## The What?

### Infrastructure

Terraform is used to create [example infrastructure](https://github.com/RustyTake-Off/aks-terraform-k8s-pipeline/tree/main/infra): Resource Group, Network, Log Analytics Workspace, User Identity, Roles and Aks. Its mostly reused from previous mini projects though slightly modified for this one.

Variables for Terraform are in the [**infra_variables**](https://github.com/RustyTake-Off/aks-terraform-k8s-pipeline/tree/main/infra_variables) folder divided further into dev and production.

### K8s

K8s deployment is an example from previous mini projects.

### Pipeline

The pipeline is constructed from separate templates so its easier to put together and maintain. Templates are separated similarly how you would use Terraform.

```txt
init => validate => plan => apply => destroy
```

Kubernetes is deployed with its own template that can be placed after terraform apply stage.

There's also a template for Checkov which scans Terraform code for any misconfigurations and potential vulnerabilities. It's best to run security scans before deploying resources.

Change all the necessary [variables](https://github.com/RustyTake-Off/aks-terraform-k8s-pipeline/blob/main/pipelines/ado_pipeline.yaml).

```yaml
variables:
  - name: backendServiceArm
    value: "" # Subscription
  - name: backendAzureRmResourceGroupName
    value: "prrgazpro05"
  - name: backendAzureRmStorageAccountName
    value: "prstraccazpro05"
  - name: backendAzureRmContainerName
    value: "prcontazpro05"
  - name: backendAzureRmKey
    value: "aztfpro05.tfstate"
  - name: environment
    value: "production"
  - name: workingDirectory
    value: "$(System.DefaultWorkingDirectory)/infra/"
  - name: terraformVersion
    value: "latest"
  - name: action
    value: ${{ parameters.Action }}
```

 And play around with the stages.
