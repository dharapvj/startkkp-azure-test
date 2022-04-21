#!/bin/bash

set -euo pipefail

readonly GENERATED_BUCKET_SUFFIX="nfodh7wt41kq"
readonly TF_STATE_BUCKET_NAME="tf-state-kkp-$GENERATED_BUCKET_SUFFIX"
readonly RG="startkkp-tfstate" # cannot be this as this gets created by terraform
readonly STORAGE_ACCT="kkpstorageacct"

echo "Setting up Azure stoage account ${STORAGE_ACCT} and container ${TF_STATE_BUCKET_NAME} for storing Terraform state."

set -x
# Create the resource group
az group create --name ${RG} --location westus

# Create the storage account
az storage account create -n ${STORAGE_ACCT} -g ${RG} -l westus --sku Standard_LRS --allow-blob-public-access false

# Create storage container
az storage container create -n ${TF_STATE_BUCKET_NAME} --account-name ${STORAGE_ACCT} --resource-group ${RG}

# Enable versioning
az storage account blob-service-properties update --enable-versioning -n ${STORAGE_ACCT} -g ${RG}

