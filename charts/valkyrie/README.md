# valkyrie

![Version: 2.6.1](https://img.shields.io/badge/Version-2.6.1-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Validates data from raw topic and writes it to validated topic

## Source Code

* <https://github.com/UrbanOS-Public/smartcitiesdata/tree/master/apps/valkyrie>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.kafka.brokers | string | `"streaming-service-kafka-bootstrap:9092"` |  |
| global.redis.host | string | `"redis.external-services"` |  |
| global.redis.password | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"smartcitiesdata/valkyrie"` |  |
| image.tag | string | `"development"` |  |
| kafka.dlqTopic | string | `"streaming-dead-letters"` |  |
| kafka.inputTopicPrefix | string | `"raw"` |  |
| kafka.outputTopicPrefix | string | `"transformed"` |  |
| localstack.enabled | bool | `false` |  |
| monitoring.targetPort | int | `9002` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| processor_stages | int | `1` |  |
| profiling_enabled | bool | `false` |  |
| replicaCount | int | `2` |  |
| resources.limits.cpu | string | `"300m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"300m"` |  |
| resources.requests.memory | string | `"512Mi"` |  |
| service.type | string | `"ClusterIP"` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)