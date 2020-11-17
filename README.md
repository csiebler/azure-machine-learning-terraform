# azure-machine-learning-terraform

This repo shows an example for rolling out a complete Azure Machine Learning enterprise enviroment via Terraform. That includes the following resources:

* Azure Machine Learning Workspace with Private Link
* Azure Storage Account with Private Link (Blob, File)
* Virtual Network
* Azure Container Registry
* Azure Application Insights
* Azure Key Vault

## Instructions

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
1. Update `terraform.tfvars` with your desired values
2. Run Terraform
    ```
    terraform init
    terraform plan
    terraform apply
    ```