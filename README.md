### Overview
This repository is an implementation of IAC that utilizies Terraform to create infrastructure for
Azure Function App. And then implements CI/CD with Github Actions that consist of workflows based on
__infra.yml__ and __function.yml__

### Pre-requisites
Following are the repository secrets to implement the infrastructure.
- ARM_ACCESS_KEY (**Storage account key** that you create for __terraform state management__)
- AZURE_CREDENTIALS (**Configure Azure Service Principal"** ) or (**az ad sp create-for-rbac --name `NAME` --role contributor --scopes /subscriptions/`SUBSCRIPTION` --sdk-auth**)
- AZURE_FUNCTIONAPP_PUBLISH_PROFILE (** to manage the CI for code azure funtion code update on __function.py__)
- AZURE_STORAGE_ACCOUNT_NAME ( **for terraform state management**)
- AZURE_STORAGE_CONTAINER_NAME (**for terraform state management**)
- Code to deploy storage account (**can name file as __storage_account-deploy.sh__**) for __terraform state management__:
    ```
    #!/bin/bash
    RESOURCE_GROUP_NAME=terraformstate
    STORAGE_ACCOUNT_NAME=terraformstate$RANDOM
    CONTAINER_NAME=tfstate
    # Create resource group
    az group create --name $RESOURCE_GROUP_NAME --location eastus
    # Create storage account
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
    # Create blob container
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
    ```
### Infrastructure deployment and How to execute workflows
- Step 01 : Is to execute __infra.yml as a **workflow-dispatch** __apply__
- Step 02 : Is to create Azure function or HTTP Trigger locally with __WORKSPACE__ and then deploy to Azure function app
- Step 03 : Then set **AZURE_FUNCTIONAPP_PACKAGE_PATH** in __function.yml__ for the **Azure Function** folder also set **AZURE_FUNCTIONAPP_NAME** same as the Azure function app while using a **workflow-dispatch** as a __push code__ this would set the pipeline in place to get the updated code for the repo for Azure function app.
- Step 04 : Copy the whole content of **AZURE_FUNCTIONAPP_PUBLISH_PROFILE** from portal and paste in repo secrets 
- Step 05 : __Getting rid of infrastructure__ simply run **Step 01** but this time run __destroy__ as a **workflow-dispatch**

