#!/bin/sh

LOCATION="westeurope"
RG_NAME="prrgazpro05"
STR_ACC_NAME="prstraccazpro05"
CONT_NAME="prcontazpro05"

# resource group
az group create --name $RG_NAME --location $LOCATION

# storage account
az storage account create --name $STR_ACC_NAME --resource-group $RG_NAME --location $LOCATION --sku Standard_LRS

# container
az storage container create --name $CONT_NAME --account-name $STR_ACC_NAME