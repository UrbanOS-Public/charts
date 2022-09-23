# UrbanOS Helm Charts

Helm charts for UrbanOS.

## Usage

Use our charts in two steps:

1. Add our repository with `helm repo add urbanos https://urbanos-public.github.io/charts/`.
2. Install a chart with `helm upgrade --install ${RELEASE_NAME} urbanos/${CHART_NAME}`. See the [Helm docs](https://helm.sh/docs/helm/#helm-upgrade) for more options.

## Contributing



### Making updates to existing charts

1. Make changes to the chart.
1. Bump the chart version as part of those changes.
1. Submit a pull request, following the PR template steps to ensure releases
   are created correctly.
1. When merged, a release will be created with new chart bundles as attachments.
   They are then available at the above mentioned helm repo under "usage".

### Creating new charts

1. Run `helm create ${CHART_NAME}` to create a new chart subdirectory.
2. Add templates, helpers, values, dependencies, etc. to your chart.
3. Submit a pull request.

## Deploying the UrbanOS Chart

### Running

- (set up a connection to a kubernetes cluster using a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) or similar)
- `helm repo add urbanos https://urbanos-public.github.io/charts/`
- Create a values file for configuring the deployment (e.g. deployment_values.yaml)
  - This file will contain configuration overrides for the deployment
- `helm upgrade --install urban-os urbanos/urban-os -f deployment_values.yaml`
- Validate with `kubectl get pods --all-namespaces`

## Documentation

Documentation per chart is generated by the [helm-docs](https://github.com/norwoodj/helm-docs) utility.

This process needs to be automated and readmes might accidentally need be out
of date until that's done.

```sh
brew install norwoodj/tap/helm-docs
helm-docs
```

## Github Actions / Pages

When PRs are merged correctly following PR template steps (up chart versions,
including urbanos, and running helm dependency update to commit new lock files),
actions will kick off a github pages build. The index.yaml file on the gh-pages
branch will contain an index of all versions of all charts. Chart tar locations
served by that index will be present as release attachments, created automatically
as part of upping the chart versions. Old charts created before this actions
workflow was implemented are available next to the index.yaml on the gh-pages
branch.
