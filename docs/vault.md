# Vault installation

This section describes the manual steps needed to configure a fresh deployment of vault on our cluster.
Here is an overview of the initialization steps:

- Deploy vault to the cluster
- Initialize the main pod
- Join the replica pods via raft
- Unseal all pods
- Apply urban-os specific configurations to the vault

### Deploy vault to the cluster with Admin Privileges

Vault is included in the urban-os charts repo. Simply deploy the urbanos charts
to deploy an instance of High Availability, Openshift enabled vault.

### Deploy vault to the cluster without Admin Privileges

If admin permissions are restricted, vault can be disabled from the urbanos
chart and deployed separately by using the official vault helm chart. You will need
to create your own values.yaml file to configure the vault deployment. Most likely,
you'll be able to copy the configuration from the urbanos chart under the `vault:` section.

```shell
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault -f <path/to/values/file>
```

For the rest of the README, references to {release_name}-... will simply ignore the {release_name}-
and include only the remainder of the command. (Note: Be sure to discard the trailing '-' as well)

# Common Vault issues

- Secrets can't be saved or retrieved
  - The vault is probably sealed. Use the `unseal_vault.sh` script
  - Sealed vaults can be recognized in k8s by being in an `unready` state
  ```
  vault-1 0/1 1 Running
  ```
  - This is often caused by the vault pod(s) rolling

### Vault cluster init

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

Store these keys in Azure Key Vault as `{release-name}-vault-key-1`, `{release-name}-vault-key-2`, etc. to allow the unseal script to work later.

### Vault Instance Setup

### Add replica to raft storage cluster

First, unseal the primary vault (See instructions below)


Then, do this only for the replicas ({release-name}-vault-1, {release-name}-vault-2, etc.)

```sh
vault operator raft join http://{release-name}-vault-0.{release-name}-vault-internal:8200
```

### Unseal the vault via helper script

For each vault in the cluster (3, per the default settings) do the following

```sh
./unseal_vault.sh {pod name} {release name} {azure keyvault name}
```

OR

### Unseal the vault via manual key entry

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
vault secrets enable -path=secrets/smart_city kv
```

### Create policies

These policies define a set of permissions. They will be bound to specific roles later.

```
cat <<EOF > ~/admin_policy.hcl
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF
vault policy write admin ~/admin_policy.hcl

cat <<EOF > ~/dataset_access_keys_policy.hcl
path "secrets/smart_city/ingestion/*" {
  capabilities = ["read", "list"]
}
EOF
vault policy write dataset_access_keys ~/dataset_access_keys_policy.hcl

cat <<EOF > ~/andi_write_only_policy.hcl
path "secrets/smart_city/ingestion/*" {
  capabilities = ["create", "update"]
}
EOF
vault policy write andi_write_only ~/andi_write_only_policy.hcl

cat <<EOF > ~/ingestion_secret_read.hcl
path "secrets/smart_city/ingestion/*" {
  capabilities = ["read"]
}
EOF
vault policy write ingestion_secret_read ~/ingestion_secret_read.hcl
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

kubernetes_host will be specific to each cluster. Run `kubectl cluster-info` to obtain the cluster host address.
Note: If `kubectl cluster-info` denies cluster side level permissions, you can add a `-n` flag to scope it to your relevant namespace.

Note: For mdot, the `cluster-info` result isn't valuable, because the URL for the cluster, relative to pods running in the
cluster is different. The cluster host address for mdot is `https://kubernetes.default.svc.cluster.local:443`.

You can confirm that you have the right cluster host address by running a healthcheck on it.
Ex: (From in a pod in the cluster, like the minio-pool pod which has curl) `curl -k https://kubernetes.default.svc.cluster.local:443/healthz` (yes, health with a z)

```
vault auth enable kubernetes

vault write auth/kubernetes/config \
    kubernetes_host={result of kubectl cluster-info or https://kubernetes.default.svc.cluster.local:443} \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    token_reviewer_jwt=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
```

### Add service roles

These commands add roles for urbanos services that use vault. The roles are bound to
a kubernetes service account, a kubernetes namespace, and a previously create policy.

After these are created, any pod in the cluster running as the specified service account will
have the permissions specified in the policy.

Note: Be sure to fill in the bound_service_account_namespaces value. If deploying through urbanos charts,
bound_service_account_names will most likely be reaper and andi, respectively.

`bound_service_account_namespaces` is a string of namespaces like `"ns-test,ns-prod"` or `"*"` for all namespaces

```
vault write auth/kubernetes/role/reaper-role \
    bound_service_account_names={service_account} \
    bound_service_account_namespaces={namespace} \
    policies=reaper_aws,dataset_access_keys \
    ttl=2m

vault write auth/kubernetes/role/andi-role \
    bound_service_account_names={service_account} \
    bound_service_account_namespaces={namespace} \
    policies=andi_auth0,andi_write_only,andi_aws_keys,ingestion_secret_read \
    ttl=2m
```
