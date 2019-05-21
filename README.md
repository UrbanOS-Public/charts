# charts
Helm charts for the SmartCitiesData platform (SCDP).

## Usage

Use our charts in two steps:

1. Add the our repository with `helm repo add scdp https://smartcitiesdata.github.io/charts`.
2. Install a chart with `helm upgrade --install ${RELEASE_NAME} scdp/${CHART_NAME}`. See the [Helm docs](https://helm.sh/docs/helm/#helm-upgrade) for more options.

If you'd like to update the chart index later, run:

```
helm repo update
```

## Contributing

### Updates

1. Make changes to the chart.
2. Bump the chart version.
3. Run `./chart.sh ${CHART_NAME}`.
4. Submit a pull request.

### New charts

1. Run `helm create ${CHART_NAME}` to create a new chart subdirectory.
2. Add templates, helpers, values, dependencies, etc. to your chart.
3. Run the setup script (`./chart.sh ${CHART_NAME}`).
4. Submit a pull request.
