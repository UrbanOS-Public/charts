# UrbanOS Helm Charts

Helm charts for the SmartCitiesData platform (SCDP).

## Usage

Use our charts in two steps:

1. Add our repository with `helm repo add scdp https://urbanos-public.github.io/charts/`.
2. Install a chart with `helm upgrade --install ${RELEASE_NAME} scdp/${CHART_NAME}`. See the [Helm docs](https://helm.sh/docs/helm/#helm-upgrade) for more options.

If you'd like to update the chart index later, run:

```
helm repo update
```

## Contributing

### Updates

1. Make changes to the chart.
2. Bump the chart version.
3. Submit a pull request.

### New charts

1. Run `helm create ${CHART_NAME}` to create a new chart subdirectory.
2. Add templates, helpers, values, dependencies, etc. to your chart.
3. Submit a pull request.

## Master Chart

### Running

- (set up a connection to a kubernetes cluster using a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) or similar)
- `helm repo add scdp https://urbanos-public.github.io/charts/`
- Create a values file for configuring the deployment (e.g. deployment_values.yaml)
  - This file will contain configuration overrides for the deployment
- `helm upgrade --install urban-os scdp/urban-os -f deployment_values.yaml`
- Validate with `kubectl get pods --all-namespaces`
