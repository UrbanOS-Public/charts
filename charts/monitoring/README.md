# monitoring

![Version: 1.1.3](https://img.shields.io/badge/Version-1.1.3-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A combination of the community Prometheus and Grafana charts.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | grafana | 6.50.8 |
| https://prometheus-community.github.io/helm-charts | prometheus | 19.6.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.ingress.annotations | object | `{}` |  |
| grafana.adminUser | string | `"admin"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".apiVersion | int | `1` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].editable | bool | `true` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].folder | string | `""` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].name | string | `"default"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].options.path | string | `"/var/lib/grafana/dashboards/default"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].orgId | int | `1` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[0].type | string | `"file"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].editable | bool | `true` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].folder | string | `""` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].name | string | `"kube"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].options.path | string | `"/var/lib/grafana/dashboards/kube"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].orgId | int | `1` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[1].type | string | `"file"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].editable | bool | `true` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].folder | string | `""` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].name | string | `"urbanos"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].options.path | string | `"/var/lib/grafana/dashboards/urbanos"` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].orgId | int | `1` |  |
| grafana.dashboardProviders."dashboardproviders.yaml".providers[2].type | string | `"file"` |  |
| grafana.dashboards.kube.kube-cluster.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.kube.kube-cluster.gnetId | int | `6873` |  |
| grafana.dashboards.kube.kube-cluster.revision | int | `2` |  |
| grafana.dashboards.kube.kube-namespace.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.kube.kube-namespace.gnetId | int | `6876` |  |
| grafana.dashboards.kube.kube-namespace.revision | int | `2` |  |
| grafana.dashboards.kube.kube-pods.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.kube.kube-pods.gnetId | int | `6879` |  |
| grafana.dashboards.kube.kube-pods.revision | int | `1` |  |
| grafana.dashboards.kube.kube-prometheus.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.kube.kube-prometheus.gnetId | int | `2` |  |
| grafana.dashboards.kube.kube-prometheus.revision | int | `2` |  |
| grafana.dashboards.urbanos.urban-os-kafka-exporter.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.urbanos.urban-os-kafka-exporter.gnetId | int | `14809` |  |
| grafana.dashboards.urbanos.urban-os-kafka-exporter.revision | int | `1` |  |
| grafana.dashboards.urbanos.urban-os-kube-all-nodes.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.urbanos.urban-os-kube-all-nodes.gnetId | int | `14810` |  |
| grafana.dashboards.urbanos.urban-os-kube-all-nodes.revision | int | `1` |  |
| grafana.dashboards.urbanos.urban-os-overview.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.urbanos.urban-os-overview.gnetId | int | `14806` |  |
| grafana.dashboards.urbanos.urban-os-overview.revision | int | `1` |  |
| grafana.dashboards.urbanos.urban-os-phoenix-api-metrics.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.urbanos.urban-os-phoenix-api-metrics.gnetId | int | `14811` |  |
| grafana.dashboards.urbanos.urban-os-phoenix-api-metrics.revision | int | `1` |  |
| grafana.dashboards.urbanos.urban-os-pipeline-health.datasource | string | `"Prometheus"` |  |
| grafana.dashboards.urbanos.urban-os-pipeline-health.gnetId | int | `14805` |  |
| grafana.dashboards.urbanos.urban-os-pipeline-health.revision | int | `1` |  |
| grafana.fullnameOverride | string | `"monitoring-grafana"` |  |
| grafana.rbac.namespaced | bool | `true` |  |
| grafana.securityContext.fsGroup | int | `1000` |  |
| grafana.securityContext.runAsGroup | int | `1000` |  |
| grafana.securityContext.runAsUser | int | `1000` |  |
| grafana.service.enabled | bool | `true` |  |
| grafana.service.type | string | `"NodePort"` |  |
| grafana.serviceAccount.create | bool | `false` |  |
| grafana.serviceAccount.name | string | `"default"` |  |
| grafana.sidecar.dashboards.enabled | bool | `true` |  |
| grafanaIngress.annotations | object | `{}` |  |
| prometheus.kube-state-metrics.enabled | bool | `false` |  |
| prometheus.prometheus-pushgateway.enabled | bool | `false` |  |
| prometheus.server.resources.limits.cpu | string | `"500m"` |  |
| prometheus.server.resources.limits.memory | string | `"1Gi"` |  |
| prometheus.server.resources.requests.cpu | string | `"250m"` |  |
| prometheus.server.resources.requests.memory | string | `"500Mi"` |  |
| prometheus.server.securityContext.fsGroup | int | `1000` |  |
| prometheus.server.securityContext.runAsGroup | int | `1000` |  |
| prometheus.server.securityContext.runAsUser | int | `1000` |  |
| prometheus.serviceAccounts.server.create | bool | `false` |  |
| prometheus.serviceAccounts.server.name | string | `"default"` |  |
| prometheusIngress.annotations | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
