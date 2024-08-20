# Vault LDAP

Using Vault's LDAP Secrets Engine, stand up 3 LDAP domains under Docker & configure Vault to generate credentials dynamically in each to illustrate how this can scale to many domains AD or LDAP.

## Create Vault & OpenLDAP & PHPLDAP via Docker Compose

```bash

brew install docker docker-compose jq vault terraform

./run all

export VAULT_ADDR=http://127.0.0.1:8200

cat ./sensitive/vault.txt | grep '^Initial' | awk '{print $4}'

export VAULT_TOKEN=$(cat ./sensitive/vault.txt | grep '^Initial' | awk '{print $4}')

vault login

vault read -format=json ldap_bar/creds/dynamic_role
vault read -format=json ldap_foo/creds/dynamic_role
vault read -format=json ldap_qux/creds/dynamic_role

open http://localhost:8080
# CN=admin,DC=bar,DC=local
# CN=admin,DC=foo,DC=local
# CN=admin,DC=qux,DC=local
# admin is the password
# see users created

./run cleanup

```

# To verify your vault init container logs:


```
docker logs compose-vaultsetup-1
```

# To verify your vault service container logs:


```
    docker logs compose-vault-1
```


