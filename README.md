# charts
Helm charts for the SmartCitiesData platform (SCDP).

## Usage

Use our charts in two steps:

1. Add our repository with `helm repo add scdp https://smartcitiesdata.github.io/charts`.
2. Install a chart with `helm upgrade --install ${RELEASE_NAME} scdp/${CHART_NAME}`. See the [Helm docs](https://helm.sh/docs/helm/#helm-upgrade) for more options.

If you'd like to update the chart index later, run:

```
helm repo update
```

## Contributing

### Updates

1. Make changes to the chart.
2. Bump the chart version.
3. Run `./package.sh ${CHART_NAME}`.
4. Submit a pull request.

### New charts

1. Run `helm create ${CHART_NAME}` to create a new chart subdirectory.
2. Add templates, helpers, values, dependencies, etc. to your chart.
3. Run the setup script (`./package.sh ${CHART_NAME}`).
4. Submit a pull request.

## Master Chart

### Running

- (install minikube)
- `minikube start`
- `helm init --upgrade`
- `helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator --version 0.08.0`
- `helm dep update master/` - rerun any time you add an app
- `helm upgrade --install master master/` 
  - if upgrade fails, try `helm delete --purge master`
  - possibly manually delete any resources that get stuck / aren't deleted by the purge
- `k get po --all-namespaces`

