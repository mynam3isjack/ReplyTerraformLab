Deploying to Azure using Terraform and GitHub Actions

- Step 1.1: Create new github repo
		- Add .gitignore by terraform template - <a href="https://github.com/github/gitignore/blob/master/Terraform.gitignore">Details</a>

- Step 1.2: Azure CLI
		- Authenticate with Azure using the az login command. (If you have access to multiple Azure subscriptions, select a specific one by running az account set -s <subscription-id>. You can see the list of subscriptions you have access to by running az account list.)

- Step 1.3: Azure service principal
		- Create an Azure service principal to run Terraform in Github Acions
		- Run the following command to create the service principal and grant it Contributor access to the Azure subscription:
			- az ad sp create-for-rbac --name "replyTerraformLab" --role Contributor --scopes /subscriptions/<subscription-id> --sdk-auth
		- Save the output of the command. You’ll need this information later in the process.
		- example:  
  
					{
					"clientId": "feadf2df-afd7-4d70-bb4d-594b5dcabdae",
					"clientSecret": "O0R626e5X4BfLZ4KV~d1d9u5w8_-r6V6x9",
					"subscriptionId": "475a2aea-10e5-4288-abc9-9efd4f3dc215",
					"tenantId": "2988608b-70b9-4911-9303-78aadfa95034",
					"activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
					"resourceManagerEndpointUrl": "https://management.azure.com/",
					"activeDirectoryGraphResourceId": "https://graph.windows.net/",
					"sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
					"galleryEndpointUrl": "https://gallery.azure.com/",
					"managementEndpointUrl": "https://management.core.windows.net/"
					}

		- More dettailed information <a href="https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret">here</a>

- Step 1.4: Download Terraform and save it in the system path
		- install terraform by chocolately plugin (windows):
    		- choco install terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
		- Create Terraform BackEnd storage account and container
			- az group create -g replyTerraformLab -l northcentralus				
				response: 

						{
						  "id": "/subscriptions/475a2aea-10e5-4288-abc9-9efd4f3dc215/resourceGroups/replyTerraformLab",
						  "location": "northcentralus",
						  "managedBy": null,
						  "name": "replyTerraformLab",
						  "properties": {
							"provisioningState": "Succeeded"
						  },
						  "tags": null,
						  "type": "Microsoft.Resources/resourceGroups"
						}	

			- az storage account create -n sareplyterraformlab -g replyTerraformLab -l northcentralus --sku Standard_LRS
				response:

						{
						  "accessTier": "Hot",
						  "allowBlobPublicAccess": true,
						  "allowCrossTenantReplication": null,
						  "allowSharedKeyAccess": null,
						  "azureFilesIdentityBasedAuthentication": null,
						  "blobRestoreStatus": null,
						  "creationTime": "2021-11-24T14:41:59.186095+00:00",
						  "customDomain": null,
						  "defaultToOAuthAuthentication": null,
						  "enableHttpsTrafficOnly": true,
						  "enableNfsV3": null,
						  "encryption": {
							"encryptionIdentity": null,
							"keySource": "Microsoft.Storage",
							"keyVaultProperties": null,
							"requireInfrastructureEncryption": null,
							"services": {
							  "blob": {
								"enabled": true,
								"keyType": "Account",
								"lastEnabledTime": "2021-11-24T14:41:59.264218+00:00"
							  },
							  "file": {
								"enabled": true,
								"keyType": "Account",
								"lastEnabledTime": "2021-11-24T14:41:59.264218+00:00"
							  },
							  "queue": null,
							  "table": null
							}
						  },
						  "extendedLocation": null,
						  "failoverInProgress": null,
						  "geoReplicationStats": null,
						  "id": "/subscriptions/475a2aea-10e5-4288-abc9-9efd4f3dc215/resourceGroups/replyTerraformLab/providers/Microsoft.Storage/storageAccounts/sareplyterraformlab",
						  "identity": null,
						  "immutableStorageWithVersioning": null,
						  "isHnsEnabled": null,
						  "keyCreationTime": {
							"key1": "2021-11-24T14:41:59.264218+00:00",
							"key2": "2021-11-24T14:41:59.264218+00:00"
						  },
						  "keyPolicy": null,
						  "kind": "StorageV2",
						  "largeFileSharesState": null,
						  "lastGeoFailoverTime": null,
						  "location": "northcentralus",
						  "minimumTlsVersion": "TLS1_0",
						  "name": "sareplyterraformlab",
						  "networkRuleSet": {
							"bypass": "AzureServices",
							"defaultAction": "Allow",
							"ipRules": [],
							"resourceAccessRules": null,
							"virtualNetworkRules": []
						  },
						  "primaryEndpoints": {
							"blob": "https://sareplyterraformlab.blob.core.windows.net/",
							"dfs": "https://sareplyterraformlab.dfs.core.windows.net/",
							"file": "https://sareplyterraformlab.file.core.windows.net/",
							"internetEndpoints": null,
							"microsoftEndpoints": null,
							"queue": "https://sareplyterraformlab.queue.core.windows.net/",
							"table": "https://sareplyterraformlab.table.core.windows.net/",
							"web": "https://sareplyterraformlab.z14.web.core.windows.net/"
						  },
						  "primaryLocation": "northcentralus",
						  "privateEndpointConnections": [],
						  "provisioningState": "Succeeded",
						  "publicNetworkAccess": null,
						  "resourceGroup": "replyTerraformLab",
						  "routingPreference": null,
						  "sasPolicy": null,
						  "secondaryEndpoints": null,
						  "secondaryLocation": null,
						  "sku": {
							"name": "Standard_LRS",
							"tier": "Standard"
						  },
						  "statusOfPrimary": "available",
						  "statusOfSecondary": null,
						  "tags": {},
						  "type": "Microsoft.Storage/storageAccounts"
						}

			- az storage container create -n terraform-state --account-name sareplyterraformlab
				response:	

						{
						  "created": true
						}

- Step 2.1: Terraform configuration
		Create a new file main.tf in the root of Git repo
		example:

				provider "azurerm" {
					version = "=2.0.0"
					features {}
					subscription_id = "475a2aea-10e5-4288-abc9-9efd4f3dc215" # jacopo.devecchis@outlook.com
  					tenant_id = "2988608b-70b9-4911-9303-78aadfa95034" # jacopo.devecchis@outlook.com
				}

				terraform {
					backend "azurerm" {
						resource_group_name  = "replyTerraformLab"
						storage_account_name = "sareplyterraformlab"
						container_name       = "terraform-state"
						key                  = "terraform.tfstate"
					}
				}

				resource "azurerm_resource_group" "replyTerraformLab_resource_group" {
					name     = "replyTerraformLab_resource_group"
					location = "northcentralus"
				}

				module "replyterraform" {
					source = "./../modules/replyterraform"
					name                = "terraformlab"
					location            = "northcentralus"
					environment = "lab"					
				}

- Step 2.2: Run terraform init to initialize Terraform.
		- You can now run terraform plan and see the execution plan.
		- This Terraform configuration allows you to test changes locally and review the execution plan before committing the changes to Git.
		- output: 
        		- "Terraform has been successfully initialized!

					You may now begin working with Terraform. Try running "terraform plan" to see
					any changes that are required for your infrastructure. All Terraform commands
					should now work.

					If you ever set or change modules or backend configuration for Terraform,
					rerun this command to reinitialize your working directory. If you forget, other
					commands will detect it and remind you to do so if necessary."

- Step 3.1: Create Github Actions 
          - Create a folder .github and a subfolder workflows in the Git repo
          - Create workflows based on GitHub Actions Workflow YAML - <a href="https://learn.hashicorp.com/tutorials/terraform/github-actions#github-actions-workflow-yaml">Details</a>



