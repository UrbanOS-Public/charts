# kafka

![Version: 1.2.28](https://img.shields.io/badge/Version-1.2.28-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart for deploying kafka via strimzi

## Source Code

* <https://github.com/strimzi/strimzi-kafka-operator>
* <https://github.com/apache/kafka>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| http://strimzi.io/charts/ | strimzi-kafka-operator | 0.42.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| kafka.broker | string | `"pipeline-kafka-bootstrap:9092"` |  |
| kafka.defaultPartitions | int | `1` |  |
| kafka.defaultReplicas | int | `3` |  |
| kafka.resources.limits.cpu | string | `"1400m"` |  |
| kafka.resources.limits.memory | string | `"12500M"` |  |
| kafka.resources.requests.cpu | string | `"1400m"` |  |
| kafka.resources.requests.memory | string | `"12500M"` |  |
| kafka.storageSize | string | `"100Gi"` |  |
| kafka.topics[0].name | string | `"streaming-persisted"` |  |
| kafka.topics[1].name | string | `"streaming-dead-letters"` |  |
| kafka.topics[2].name | string | `"event-stream"` |  |
| kafka.version | string | `"3.7.0"` |  |
| kafkaExporter.enabled | bool | `true` |  |
| limitRange.enabled | bool | `true` |  |
| rbac.enabled | bool | `true` |  |
| resizeHook.enabled | bool | `true` |  |
| scraper.cron | string | `"*/10 * * * *"` |  |
| scraper.enabled | bool | `false` |  |
| scraper.endpoint | string | `"kafka-exporter:9308/metrics"` |  |
| scraper.image | string | `"alpine:latest"` |  |
| scraper.serviceAccount | string | `"default"` |  |
| strimzi-kafka-operator.enabled | bool | `true` |  |
| strimzi-kafka-operator.resources.limits.cpu | string | `"500m"` |  |
| strimzi-kafka-operator.resources.requests.cpu | string | `"100m"` |  |
| tlsSidecar.resources.limits.cpu | string | `"100m"` |  |
| tlsSidecar.resources.limits.memory | string | `"128Mi"` |  |
| tlsSidecar.resources.requests.cpu | string | `"100m"` |  |
| tlsSidecar.resources.requests.memory | string | `"128Mi"` |  |
| tolerations | list | `[]` |  |
| zookeeper.resources.limits.cpu | string | `"100m"` |  |
| zookeeper.resources.limits.memory | string | `"512Mi"` |  |
| zookeeper.resources.requests.cpu | string | `"100m"` |  |
| zookeeper.resources.requests.memory | string | `"512Mi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
