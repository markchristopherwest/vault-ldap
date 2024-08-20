terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.24.0"
    }
  }
}

provider "vault" {
  # Configuration options
  # address = "http://127.0.0.1:8200"
  # skip_tls_verify = true
}

data "vault_policy_document" "ldap" {
  rule {
    path         = "ldap_*/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "Work with LDAP secrets engine"
  }
  rule {
    path         = "sys/mounts/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "Enable secrets engine"
  }
  rule {
    path         = "sys/mounts"
    capabilities = [ "read", "list"]
    description  = "List enabled secrets engine"
  }
}

resource "vault_policy" "ldap" {
  name   = "ldap_policy"
  policy = data.vault_policy_document.ldap.hcl
}

resource "vault_ldap_secret_backend" "config" {
  for_each = {
    for k, v in var.ldap_manifest : k => v
  }
  path          = "ldap_${each.key}"
  description = "ldap secrets engine for ${each.key}"
  binddn        = "${each.value.binddn}"
  bindpass      = "${each.value.bindpass}"
  url           = "${each.value.url}"
  userdn        = "${each.value.userdn}"
}

resource "random_pet" "server" {
}

resource "vault_ldap_secret_backend_dynamic_role" "role" {
  for_each = {
    for k, v in var.ldap_manifest : k => v
  }
  mount         = vault_ldap_secret_backend.config[each.key].path
  role_name     = "dynamic_role"
  creation_ldif = each.value.creation_ldif
  deletion_ldif = each.value.deletion_ldif
  rollback_ldif = each.value.rollback_ldif
  default_ttl   = each.value.default_ttl
  max_ttl       = each.value.max_ttl
}

# data "vault_ldap_dynamic_credentials" "creds_bar" {
#   mount     = vault_ldap_secret_backend.config["bar"].path
#   role_name = vault_ldap_secret_backend_dynamic_role.role["bar"].role_name
# }

# output "creds_bar_username" {
#   value = data.vault_ldap_dynamic_credentials.creds_bar.username
# }

# output "creds_bar_password" {
#   value = data.vault_ldap_dynamic_credentials.creds_bar.password
# }


# data "vault_ldap_dynamic_credentials" "creds_foo" {
#   mount     = vault_ldap_secret_backend.config["foo"].path
#   role_name = vault_ldap_secret_backend_dynamic_role.role["foo"].role_name
# }

# output "creds_foo_username" {
#   value = data.vault_ldap_dynamic_credentials.creds_foo.username
# }

# output "creds_foo_password" {
#   value = data.vault_ldap_dynamic_credentials.creds_foo.password
# }

# data "vault_ldap_dynamic_credentials" "creds_qux" {
#   mount     = vault_ldap_secret_backend.config["qux"].path
#   role_name = vault_ldap_secret_backend_dynamic_role.role["qux"].role_name
# }

# output "creds_qux_username" {
#   value = data.vault_ldap_dynamic_credentials.creds_qux.username
# }

# output "creds_qux_password" {
#   value = data.vault_ldap_dynamic_credentials.creds_qux.password
# }
