# resource "azurerm_key_vault" "kv" {
#   name                = local.kv_name
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = var.location
#   sku_name            = "standard"
#   tenant_id           = data.azurerm_client_config.current.tenant_id

#   soft_delete_retention_days = 7
#   purge_protection_enabled   = false

#   # Do not use Azure RBAC, because Application Gateway does not support it properly:
#   # https://docs.microsoft.com/en-us/azure/application-gateway/key-vault-certs#key-vault-azure-role-based-access-control-permission-model
#   enable_rbac_authorization = false

#   enabled_for_deployment          = true
#   enabled_for_disk_encryption     = true
#   enabled_for_template_deployment = true

#   tags = {
#     environment = var.env
#   }
# }

# # Key Vault check: ETL license
# # - Secret check returns "404 - Not Found", so the following postcondition check will not kick in
# data "azurerm_key_vault_secret" "etl_license_secret" {
#   name         = local.kv_secret_name_etl_license
#   key_vault_id = azurerm_key_vault.kv.id
#   lifecycle {
#     postcondition {
#       condition     = self.id != null
#       error_message = "ETL license must be uploaded to key vault '${azurerm_key_vault.kv.name}' as '${local.kv_secret_name_etl_license}'"
#     }
#   }
#   depends_on = [
#     azurerm_key_vault.kv,
#     azurerm_key_vault_access_policy.kvaccess_deployer
#   ]
# }

# # Key Vault check: PEM certificate for HTTPS in AppGW
# # - Certificate check does not return "404 - Not Found", so using a post condition check with a proper error message
# data "azurerm_key_vault_certificate" "frontend_cert" {
#   name         = local.kv_cert_name_frontend
#   key_vault_id = azurerm_key_vault.kv.id
#   lifecycle {
#     postcondition {
#       condition     = self.id != null
#       error_message = <<EOM
#         PEM frontend certificate must be uploaded to key vault '${azurerm_key_vault.kv.name}' as '${local.kv_cert_name_frontend}', e.g.:
#         az keyvault certificate import --vault-name "${azurerm_key_vault.kv.name}" -n "${local.kv_cert_name_frontend}" -f "/path/to/${var.project_name}-${var.env}.pfx" -o none
#         Make sure, the ETL license is uploaded as well, e.g.:
#         az keyvault secret set --vault-name "${azurerm_key_vault.kv.name}" -n  "${local.kv_secret_name_etl_license}" -f "/path/to/${local.kv_secret_name_etl_license}.lic" -o none
#       EOM
#     }
#   }
#   depends_on = [
#     azurerm_key_vault.kv,
#     azurerm_key_vault_access_policy.kvaccess_deployer
#   ]
# }
