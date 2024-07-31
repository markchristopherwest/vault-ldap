# Vault LDAP

Using Vault's LDAP Secrets Engine, stand up 3 LDAP domains under Docker & configure Vault to generate credentials dynamically in each to illustrate how this can scale to many domains AD or LDAP.

## Create Vault & MongoDB via Docker Compose

```bash

./run all

cat ./sensitive/vault.txt | grep '^Initial' | awk '{print $4}'

vault login

vault read ldap_bar/creds/dynamic-role

vault read ldap_foo/creds/dynamic-role

vault read ldap_qux/creds/dynamic-role

open http://localhost:8080
# CN=admin,DC=qux,DC=local
# admin is the password
# see users created

./run cleanup

```

# To verify your vault init container logs:

docker logs tools-vaultsetup-1

# To verify your vault service container logs:

docker logs tools-vault-1


```


