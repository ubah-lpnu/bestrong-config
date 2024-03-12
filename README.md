# Terraform Infrastructure Configuration
This repository contains Terraform code for configuring various Azure resources as described in the task.

## Overview
The Terraform configuration included in this repository creates the following resources:

- 1 App Service Plan
- 1 App Service integrated with VNet and System Managed Identity enabled
- 1 Application Insights linked to the App Service
- 1 Azure Container Registry (ACR) with App Service Identity access
- 1 Key Vault with permissions granted to App Service Identity and integrated with VNet
- 1 Virtual Network (VNet)
- 1 Microsoft SQL Server DB with Private Endpoint configured
- 1 Storage Account with Private Endpoint configured with VNet and Fileshare mounted to the App Service
- 1 Storage Account for Terraform state
- **The Terraform state is stored in a remote backend, specifically an Azure storage account.**
