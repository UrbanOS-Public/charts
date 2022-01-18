# discovery-api

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![AppVersion: 1.0.0-static](https://img.shields.io/badge/AppVersion-1.0.0--static-informational?style=flat-square)

A middleware layer to connect data consumers with the data sources

## Source Code

* <https://github.com/UrbanOS-Public/smartcitiesdata/tree/master/apps/discovery_api>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.client_id | string | `"1234"` |  |
| auth.domain | string | `"example.com"` |  |
| auth.jwks_endpoint | string | `"https://example.com/.well-known/jwks.json"` |  |
| auth.jwt_issuer | string | `"https://example.com/"` |  |
| auth.redirect_base_url | string | `"http://localhost"` |  |
| auth.user_info_endpoint | string | `"https://example.com/userinfo"` |  |
| aws.accessKeyId | string | `""` |  |
| aws.accessKeySecret | string | `""` |  |
| elasticsearch.host | string | `"es.example.com"` |  |
| elasticsearch.tls | bool | `true` |  |
| global.auth.auth0_domain | string | `""` |  |
| global.auth.jwt_issuer | string | `""` |  |
| global.buckets.hostedFileBucket | string | `"dataset-bucket"` |  |
| global.buckets.region | string | `"us-west-2"` |  |
| global.ingress.dnsZone | string | `"localhost"` |  |
| global.ingress.rootDnsZone | string | `"localhost"` |  |
| global.kafka.brokers | string | `"pipeline-kafka-bootstrap:9092"` |  |
| global.presto.url | string | `"http://platform-kubernetes-data-platform-presto:8080"` |  |
| global.redis.host | string | `"redis.external-services"` |  |
| global.redis.password | string | `""` |  |
| global.vault.endpoint | string | `"vault.vault:8200"` |  |
| image.name | string | `"smartcitiesdata/discovery_api"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `"development"` |  |
| ingress.annotations | string | `nil` |  |
| ldap.account.subdn | string | `"cn=users,cn=accounts"` |  |
| ldap.base | string | `"dc=example,dc=com"` |  |
| ldap.host | string | `"ldap.example.com"` |  |
| ldap.user | string | `"binduser"` |  |
| monitoring.targetPort | int | `9002` |  |
| nodeSelector | object | `{}` |  |
| postgres.dbname | string | `"postgres"` |  |
| postgres.host | string | `"example.com"` |  |
| postgres.password | string | `"password"` |  |
| postgres.port | string | `"5432"` |  |
| postgres.user | string | `"postgres"` |  |
| presto.catalog | string | `"hive"` |  |
| presto.schema | string | `"default"` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | int | `1` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | int | `1` |  |
| resources.requests.memory | string | `"512Mi"` |  |
| secrets.discoveryApiPresignKey | string | `""` |  |
| service.auth_string | string | `""` |  |
| service.name | string | `"discovery-api"` |  |
| service.port | int | `80` |  |
| service.type | string | `"NodePort"` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)