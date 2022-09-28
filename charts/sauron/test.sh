    #!/bin/bash
  
  
    re="^https:\/\/github.com\/(.+)\/(.+).git*$"
    
    if [[ "$GIT_HTTPS_CLONE_URL" =~ $re ]]; then
      USER=${BASH_REMATCH[1]}
    echo "User: $USER"
      printf "\n\n"
    
      REPO=${BASH_REMATCH[2]}
    echo "Repo: $REPO"
      printf "\n\n"
    fi
    
    
    TARGET_DEPLOYMENT_SHA=$(curl \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
        "https://api.github.com/repos/$USER/$REPO/branches/$TARGET_BRANCH" | jq '.commit.sha' | sed 's/"//g' )
    printf "TARGET_DEPLOYMENT_SHA: %s \n\n" "$TARGET_DEPLOYMENT_SHA"
    printf "CURRENT_DEPLOYMENT_SHA: %s \n\n" "$CURRENT_DEPLOYMENT_SHA"
    
    if [[ $CURRENT_DEPLOYMENT_SHA != "$TARGET_DEPLOYMENT_SHA" ]]; then
      echo "Github SHA used for the current deployment does not match the SHA of the configured target branch."
      echo "Deploying with content from configured target branch."
      printf "gitHttpsCloneUrl: %s" "$GIT_HTTPS_CLONE_URL"
      printf "Target branch: %s" "$TARGET_BRANCH"
    
      helm repo add urbanos https://urbanos-public.github.io/charts/
      
      {{ if .Values.remoteDeployment.secrets.persistence.trino.enabled }}
      # the below secrets were unable to be templated in properly through
      # just the values file, due to errors with string quotes,
      # so this is a workaround to apply them as their own file, skipping template
      # parsing.
      cat << EOT > hive_catalog.yaml
    persistence:
      trino:
        additionalCatalogs:
          hive: |
            connector.name=hive-hadoop2
            hive.metastore.uri=thrift://hive-metastore:8000
            hive.metastore.username=padmin
            hive.metastore-timeout=360m
            hive.allow-drop-table=true
            hive.allow-rename-table=true
            hive.allow-drop-column=true
            hive.allow-rename-column=true
            hive.allow-add-column=true
            hive.s3.aws-access-key=$GLOBAL_OBJECTSTORE_ACCESSKEY
            hive.s3.aws-secret-key=$GLOBAL_OBJECTSTORE_ACCESSSECRET
            hive.s3.path-style-access=true
            hive.s3.endpoint=$MINIO_ENDPOINT
            hive.s3.ssl.enabled=false
      EOT
      {{ end -}}
    
    
      git clone "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${USER}/${REPO}.git"
      cd "$REPO" || exit 0
      git checkout "$TARGET_BRANCH"
      
      if [[ -s "$VALUES_FILE_FROM_REPO_ROOT" ]]; then
        helm repo update
    
        helm upgrade --install "$RELEASE_NAME" urbanos/urban-os   \
        --values="$VALUES_FILE_FROM_REPO_ROOT" \
        {{- if .Values.remoteDeployment.secrets.persistence.trino.enabled -}}
        --values=hive_catalog.yaml \ 
        {{ end -}}
        {{- if .Values.global.objectStore.accessKey -}}
        --set global.objectStore.accessKey=$GLOBAL_OBJECTSTORE_ACCESSKEY \
        {{ end -}}
        {{- if .Values.global.objectStore.accessSecret -}}
        --set global.objectStore.accessSecret=$GLOBAL_OBJECTSTORE_ACCESSSECRET \
        {{ end -}}
        {{- if .Values.remoteDeployment.secrets.raptor.auth.auth0_client_secret -}}
        --set raptor.auth.auth0_client_secret=$RAPTOR_AUTH0_CLIENT_SECRET \ 
        --set sauron.remoteDeployment.secrets.raptor.auth.auth0_client_secret=$RAPTOR_AUTH0_CLIENT_SECRET \
        {{ end -}}
        {{- if index .Values.remoteDeployment.secrets "discovery-api" "secrets" "discoveryApiPresignKey" -}}
        --set discovery-api.secrets.discoveryApiPresignKey=$DISCOVERY_API_PRESIGN_KEY \
        --set sauron.remoteDeployment.secrets.discovery-api.secrets.discoveryApiPresignKey=$DISCOVERY_API_PRESIGN_KEY \
        {{ end -}}
        {{- if index .Values.remoteDeployment.secrets "discovery-api" "secrets" "guardianSecretKey" -}}
        --set discovery-api.secrets.guardianSecretKey=$DISCOVERY_API_GUARDIAN_KEY \
        --set sauron.remoteDeployment.secrets.discovery-api.secrets.guardianSecretKey=$DISCOVERY_API_GUARDIAN_KEY \
        {{ end -}}
        {{- if index .Values.remoteDeployment.secrets "discovery-api" "postgres" "password" -}}
        --set discovery-api.postgres.password=$DISCOVERY_API_POSTGRES_PASSWORD \
        --set sauron.remoteDeployment.secrets.discovery-api.postgres.password=$DISCOVERY_API_POSTGRES_PASSWORD \
        {{ end -}}
        {{- if .Values.remoteDeployment.secrets.andi.postgres.password -}}
        --set andi.postgres.password=$ANDI_POSTGRES_PASSWORD \
        --set sauron.remoteDeployment.secrets.andi.postgres.password=$ANDI_POSTGRES_PASSWORD \
        {{ end -}}
        {{ if .Values.remoteDeployment.secrets.andi.auth.auth0_client_secret -}}
        --set andi.auth.auth0_client_secret=$ANDI_AUTH0_CLIENT_SECRET \
        --set sauron.remoteDeployment.secrets.andi.auth.auth0_client_secret=$ANDI_AUTH0_CLIENT_SECRET \
        {{ end -}}
        {{- if .Values.remoteDeployment.secrets.persistence.metastore.postgres.password -}}
        --set persistence.metastore.postgres.password=$PERSISTENCE_POSTGRES_PASSWORD \
        --set sauron.remoteDeployment.secrets.persistence.metastore.postgres.password=$PERSISTENCE_POSTGRES_PASSWORD \
        {{ end -}}
        {{- if .Values.remoteDeployment.proxyAccountPAT -}}
        --set sauron.remoteDeployment.proxyAccountPAT=$SAURON_PROXY_PAT \
        {{ end -}}
        --namespace="$NAMESPACE"
      
      else
        echo "Values file could not be found or is empty. Skipping deployment."
        printf "Configured file path from repo root: %s \n\n\n" "$VALUES_FILE_FROM_REPO_ROOT" 
      fi
      
    else
      echo "Current deployment SHA matches the SHA of the configured target branch. Skipping deployment."
    fi