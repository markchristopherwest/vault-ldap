
variable "ldap_manifest" {
  type = map(object({
        path          = string
        binddn        = string
        bindpass      = string
        url           = string
        userdn        = string
        creation_ldif        = string
        deletion_ldif        = string
        rollback_ldif        = string
        default_ttl   = number
        max_ttl       = number
  }))
  default = {
    # https://developer.hashicorp.com/vault/docs/secrets/ldap#active-directory-ad
    # https://developer.hashicorp.com/vault/docs/secrets/ldap#active-directory-ad-1
    # https://developer.hashicorp.com/vault/docs/secrets/ldap#active-directory-ldif-example
    bar = {
        path          = "bar"
        binddn        = "CN=admin,DC=bar,DC=local"
        bindpass      = "admin"
        url           = "ldap://openldap-bar"
        userdn        = "DC=bar,DC=local"
        creation_ldif = <<EOT
dn: uid={{.Username}},dc=bar,dc=local
uid: {{.Username}}
cn: {{.Username}}
sn: 3
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/{{.Username}}
uidNumber: 14583102
gidNumber: 14564100
userPassword: {{.Username}}
mail: {{.Username}}@bar.local
gecos: {{.Username}}
EOT
        deletion_ldif = <<EOT
dn: uid={{.Username}},dc=bar,dc=local
changetype: delete
EOT
        rollback_ldif = <<EOT
dn: uid={{.Username}},dc=bar,dc=local
changetype: delete
EOT
        default_ttl   = 3600
        max_ttl       = 86400
    }
    foo = {
        path          = "foo"
        binddn        = "CN=admin,DC=foo,DC=local"
        bindpass      = "admin"
        url           = "ldap://openldap-foo"
        userdn        = "DC=foo,DC=local"
        creation_ldif = <<EOT
dn: uid={{.Username}},dc=foo,dc=local
uid: {{.Username}}
cn: {{.Username}}
sn: 3
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/{{.Username}}
uidNumber: 14583102
gidNumber: 14564100
userPassword: {{.Username}}
mail: {{.Username}}@foo.local
gecos: {{.Username}}
EOT
        deletion_ldif = <<EOT
dn: uid={{.Username}},dc=foo,dc=local
changetype: delete
EOT
        rollback_ldif = <<EOT
dn: uid={{.Username}},dc=foo,dc=local
changetype: delete
EOT
        default_ttl   = 3600
        max_ttl       = 86400
    }
    qux = {
        path          = "qux"
        binddn        = "CN=admin,DC=qux,DC=local"
        bindpass      = "admin"
        url           = "ldap://openldap-qux"
        userdn        = "DC=qux,DC=local"
        creation_ldif = <<EOT
dn: uid={{.Username}},dc=qux,dc=local
uid: {{.Username}}
cn: {{.Username}}
sn: 3
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/{{.Username}}
uidNumber: 14583102
gidNumber: 14564100
userPassword: {{.Username}}
mail: {{.Username}}@qux.local
gecos: {{.Username}}
EOT
        deletion_ldif = <<EOT
dn: uid={{.Username}},dc=qux,dc=local
changetype: delete
EOT
        rollback_ldif = <<EOT
dn: uid={{.Username}},dc=qux,dc=local
changetype: delete
EOT
        default_ttl   = 3600
        max_ttl       = 86400
    }
  }
  description = "Resource map"
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
