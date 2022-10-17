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

### Vault



# On the care and feeding of Vault

Vault is a service that we manage, so if anything goes wrong or down we need to be able to repair it quickly. The scripts in this file should help with that.

## Common issues

###### Add to this as we learn more

- Secrets can't be saved or retrieved
    - The vault is probably sealed. Use the `unseal_vault.sh` script
    - Sealed vaults can be recognized in k8s by being in an `unready` state
  ```
  vault-1 0/1 1 Running
  ```
    - This is often caused by the vault pod(s) rolling

## Vault installation

This section describes the manual steps needed to configure a fresh deployment of vault on our cluster.
Here is an overview of the initialization steps:
- Deploy vault to the cluster
- Initialize the main pod
- Join the replica pods via raft
- Unseal all pods
- Apply urban-os specific configurations to the vault


#### Deploy vault to the cluster

Vault is included in the urban-os charts repo. Simply deploy the urbanos charts
to deploy an instance of High Availability, Openshift enabled vault.

#### Vault cluster init

Initializing the vault will create the unseal keys and the root key.
This only needs to be performed on a single pod of the cluster. After the main pod has been initialized,
you must join the replica pods to the "raft" before unsealing the replicas (See Raft section below)

Note: If you accidentally initialize a replica pod separately, you can "uninitialize" the
pod by shelling into the replica and clearing the configured data location: /vault/data (It may be /etc/vault/data for some clusters)
You will need to restart the pod for it to detect the configuration wipe.

On {release-name}-vault-0, run

```sh
vault operator init
```

```
Unseal Key 1: [REDACTED]
Unseal Key 2: [REDACTED]
Unseal Key 3: [REDACTED]
Unseal Key 4: [REDACTED]
Unseal Key 5: [REDACTED]

Initial Root Token: [REDACTED]
```

Store these keys in a secure place. You will not be able to retrieve them.

### Vault Instance Setup

### Add replica to raft storage cluster

Do this only for the replicas ({release-name}-vault-1, {release-name}-vault-2, etc.)

```sh
vault operator raft join http://{release-name}-vault-0.{release-name}-vault-internal:8200
```

### Unseal the vault via helper script

Unsealing a vault pod requires multiple keys be entered. For each vault pod on the cluster, run 
the following command and enter a different unseal key each time.

```sh
vault operator unseal
```

Do this 3-4 times using different keys until the output looks like

```
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            5
Threshold               3
Version                 1.9.2
Storage Type            raft
Cluster Name            vault-cluster-5981c796
Cluster ID              [REDACTED]
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    25
Raft Applied Index      25
```

## Vault configuration

On {release-name}-vault-0,

### Login to Vault as root

```sh
vault login
# use the root token above
```

### Enable the KV secret engine
This enables the ability to store key/value pairs from our elixir apps

```
vault secrets enable secrets/smart_city
vault secrets enable kv
```

### Create policies

These policies define a set of permissions. They will be bound to specific roles later.


```
cat <<EOF >admin_policy.hcl
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF
vault policy write admin ~/admin_policy.hcl

cat <<EOF >dataset_access_keys_policy.hcl
path "secrets/smart_city/ingestion/*" {
  capabilities = ["read", "list"]
}
EOF
vault policy write dataset_access_keys ~/dataset_access_keys_policy.hcl

cat <<EOF >andi_write_only_policy.hcl
path "secrets/smart_city/ingestion/*" {
  capabilities = ["create", "update"]
}
EOF
vault policy write andi_write_only ~/andi_write_only_policy.hcl
```

### Enable Admin Login

This enables "userpass" auth method, adds an admin user, sets a password, and binds it to the admin policy

```
vault auth enable userpass

# A new admin password will need to be generated if this is a fresh install and stored in a team password manager or key store
vault write auth/userpass/users/admin password=$VAULT_ADMIN_PASSWORD policies=admin
```


### Enables Kubernetes Service Account Login

This is the primary auth method urbanos uses. Allows for kubernetes service accounts
to automatically authenticate to vault.

```
vault auth enable kubernetes

vault write auth/kubernetes/config \
    kubernetes_host=https://api.hsrqs9l3.eastus.aroapp.io:6443 \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    token_reviewer_jwt=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
```

### Add service roles

These commands add roles for urbanos services that use vault. The roles are bound to
a kubernetes service account, a kubernetes namespace, and a previously create policy.

After these are created, any pod in the cluster running as the specified service account will
have the permissions specified in the policy.

```
vault write auth/kubernetes/role/reaper-role \
    bound_service_account_names=reaper \
    bound_service_account_namespaces=dev \
    policies=reaper_aws,dataset_access_keys \
    ttl=2m

vault write auth/kubernetes/role/andi-role \
    bound_service_account_names=andi \
    bound_service_account_namespaces=dev \
    policies=andi_auth0,andi_write_only,andi_aws_keys \
    ttl=2m
```


### Sauron

Sauron is our automated deployment updater. Sauron must first be independently deployed, then it will detect upstream changes and issue deployment commands as needed.

Sauron's responsibilities include:
- Detecting docker hub image patch updates and triggering a pod image update if using deployment tag
- Detecting upstream Remote Deployment Repo's changes and issuing an automated deployment command with all known secrets and values from current deployment and remote repo, respectively. 

Sauron will:
- First check for docker image patch updates (Current functionality)
- Then it will check if the Remote Deployment Repo's target branch SHA matches the SHA most recently used by Sauron
- If not, it will clone the Remote Deployments Repo with the GITHUB_TOKEN provided in the Sauron deployment
- It will then use the secrets that were provided in the Sauron Deployment to issue a helm upgrade --install of urban-os, using the latest chart version. It will also use the values file (From the remote repo) that was specified in the Sauron deployment config.

Deploying Sauron:

- Initial Sauron deployment should be manually done, similar to urban-os deployments. Be sure to override all secrets defined in the values.yaml file.
- Sauron only needs to be updated if secrets change, or if the sauron chart itself changes
- Sauron currently needs to run as a specific user. Be sure it has permissions on a cluster level: `oc adm policy add-scc-to-user anyuid -z updater-cron`


How to use:

- Simply merge any change into the configured Remote Deployment Repo
- The cronjob will automatically update your urban-os deployment with the new values file from the remote deployment repo.

## Git Hooks

To install from root:
```shell
./scripts/install_git_hooks.sh
```

## Documentation

Documentation per chart is generated by the [helm-docs](https://github.com/norwoodj/helm-docs) utility.

Helm-docs has now been integrated into pre-commit hooks. See the Git Hooks section to install.

If you're on MacOS, the pre-commit hook will automatically install helm-docs if not present.
If you're on windows, you must manually install with scoop.

## Github Actions / Pages

When PRs are merged correctly following PR template steps (up chart versions,
including urbanos, and running helm dependency update to commit new lock files),
actions will kick off a github pages build. The index.yaml file on the gh-pages
branch will contain an index of all versions of all charts. Chart tar locations
served by that index will be present as release attachments, created automatically
as part of upping the chart versions. Old charts created before this actions
workflow was implemented are available next to the index.yaml on the gh-pages
branch.
