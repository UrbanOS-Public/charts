# vault

![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A custom chart for the vault secrets engine in support of the UrbanOS platform.

## Source Code

* <https://github.com/hashicorp/vault>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminPassword | string | `"admin"` |  |
| authMethod | string | `""` |  |
| jq.version | string | `"1.6"` |  |
| kubectl.version | string | `"1.14.0"` |  |
| ldap.basedn | string | `"basedn"` |  |
| ldap.bindpass | string | `"bindpass"` |  |
| ldap.binduser | string | `"binduser"` |  |
| ldap.groupattr | string | `"groupattr"` |  |
| ldap.groupdn | string | `"groupdn"` |  |
| ldap.insecure_tls | string | `"insecure_tls"` |  |
| ldap.server | string | `"server"` |  |
| ldap.start_tls | string | `"start_tls"` |  |
| ldap.userattr | string | `"userattr"` |  |
| ldap.userdn | string | `"userdn"` |  |
| vault.clusterPort | int | `8201` |  |
| vault.config.listener.tcp.address | string | `"[::]:8200"` |  |
| vault.config.listener.tcp.cluster_address | string | `"[::]:8201"` |  |
| vault.config.listener.tcp.tls_cipher_suites | string | `"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA"` |  |
| vault.config.listener.tcp.tls_disable | bool | `true` |  |
| vault.config.listener.tcp.tls_prefer_server_cipher_suites | bool | `true` |  |
| vault.config.storage.file.path | string | `"/keys"` |  |
| vault.liveness.initialDelaySeconds | int | `30` |  |
| vault.liveness.periodSeconds | int | `10` |  |
| vault.policies[0].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[0].name | string | `"dataset_access_keys"` |  |
| vault.policies[0].path | string | `"secrets/smart_city/ingestion/*"` |  |
| vault.policies[1].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[1].name | string | `"reaper_aws"` |  |
| vault.policies[1].path | string | `"secrets/smart_city/aws_keys/reaper"` |  |
| vault.policies[2].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[2].name | string | `"odo_aws"` |  |
| vault.policies[2].path | string | `"secrets/smart_city/aws_keys/odo"` |  |
| vault.policies[3].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[3].name | string | `"discovery_api_aws"` |  |
| vault.policies[3].path | string | `"secrets/smart_city/aws_keys/discovery_api"` |  |
| vault.policies[4].capabilities | string | `"[\"create\", \"update\"]"` |  |
| vault.policies[4].name | string | `"andi_write_only"` |  |
| vault.policies[4].path | string | `"secrets/smart_city/ingestion/*"` |  |
| vault.policies[5].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[5].name | string | `"andi_aws_keys"` |  |
| vault.policies[5].path | string | `"secrets/smart_city/aws_keys/andi"` |  |
| vault.policies[6].capabilities | string | `"[\"read\", \"list\"]"` |  |
| vault.policies[6].name | string | `"andi_auth0"` |  |
| vault.policies[6].path | string | `"secrets/smart_city/auth0/andi"` |  |
| vault.port | int | `8200` |  |
| vault.pullPolicy | string | `"IfNotPresent"` |  |
| vault.readiness.initialDelaySeconds | int | `10` |  |
| vault.readiness.periodSeconds | int | `10` |  |
| vault.repository | string | `"vault"` |  |
| vault.roles[0].boundServiceAccountNamespaces | string | `"urban-os"` |  |
| vault.roles[0].boundServiceAccounts | string | `"discovery-api"` |  |
| vault.roles[0].name | string | `"discovery-api-role"` |  |
| vault.roles[0].policies | string | `"discovery_api_aws"` |  |
| vault.roles[0].tokenTtl | string | `"2m"` |  |
| vault.roles[1].boundServiceAccountNamespaces | string | `"urban-os"` |  |
| vault.roles[1].boundServiceAccounts | string | `"reaper"` |  |
| vault.roles[1].name | string | `"reaper-role"` |  |
| vault.roles[1].policies | string | `"reaper_aws,dataset_access_keys"` |  |
| vault.roles[1].tokenTtl | string | `"2m"` |  |
| vault.roles[2].boundServiceAccountNamespaces | string | `"urban-os"` |  |
| vault.roles[2].boundServiceAccounts | string | `"odo"` |  |
| vault.roles[2].name | string | `"odo-role"` |  |
| vault.roles[2].policies | string | `"odo_aws"` |  |
| vault.roles[3].boundServiceAccountNamespaces | string | `"urban-os"` |  |
| vault.roles[3].boundServiceAccounts | string | `"andi"` |  |
| vault.roles[3].name | string | `"andi-role"` |  |
| vault.roles[3].policies | string | `"andi_auth0,andi_write_only,andi_aws_keys"` |  |
| vault.roles[3].tokenTtl | string | `"2m"` |  |
| vault.roles[4].boundServiceAccountNamespaces | string | `"urban-os"` |  |
| vault.roles[4].boundServiceAccounts | string | `"andi-public"` |  |
| vault.roles[4].name | string | `"andi-public-role"` |  |
| vault.roles[4].policies | string | `"andi_auth0,andi_aws_keys"` |  |
| vault.roles[4].tokenTtl | string | `"2m"` |  |
| vault.secretsPath | string | `"secrets/smart_city"` |  |
| vault.tag | string | `"1.3.1"` |  |
| vault.volumeSize | string | `"5Gi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
