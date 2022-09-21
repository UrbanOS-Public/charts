# persistence

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)

Data persistence for UrbanOS using Trino and the Hive Metastore

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.s3.accessKey | string | `"example"` |  |
| global.s3.hiveStorageBucket | string | `"hive-storage"` |  |
| global.s3.hiveStoragePath | string | `nil` |  |
| global.s3.host | string | `"example.com"` |  |
| global.s3.port | int | `8000` |  |
| global.s3.secretKey | string | `"example"` |  |
| metastore.postgres.host | string | `"postgres"` |  |
| metastore.postgres.name | string | `"metastore"` |  |
| metastore.postgres.password | string | `"example"` |  |
| metastore.postgres.port | int | `5432` |  |
| metastore.postgres.user | string | `"padmin"` |  |
| metastore.resources.limits.cpu | int | `1` |  |
| metastore.resources.limits.memory | string | `"2Gi"` |  |
| metastore.resources.requests.cpu | int | `1` |  |
| metastore.resources.requests.memory | string | `"2Gi"` |  |
| trino.additionalCatalogs.hive | string | `"connector.name=hive-hadoop2\nhive.metastore.uri=thrift://hive-metastore:8000\nhive.metastore.username=padmin\nhive.metastore-timeout=360m\nhive.allow-drop-table=true\nhive.allow-rename-table=true\nhive.allow-drop-column=true\nhive.allow-rename-column=true\nhive.allow-add-column=true\nhive.s3.aws-access-key=EXAMPLE\nhive.s3.aws-secret-key=EXAMPLE\nhive.s3.path-style-access=true\nhive.s3.endpoint=http://minio:80\nhive.s3.ssl.enabled=false"` |  |
| trino.coordinator.resources.limits.cpu | int | `1` |  |
| trino.coordinator.resources.limits.memory | string | `"2Gi"` |  |
| trino.coordinator.resources.requests.cpu | int | `1` |  |
| trino.coordinator.resources.requests.memory | string | `"2Gi"` |  |
| trino.serviceAccount.create | bool | `true` |  |
| trino.serviceAccount.name | string | `"trino"` |  |
| trino.worker.resources.limits.cpu | int | `1` |  |
| trino.worker.resources.limits.memory | string | `"2Gi"` |  |
| trino.worker.resources.requests.cpu | int | `1` |  |
| trino.worker.resources.requests.memory | string | `"2Gi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)