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
        hive.s3.aws-access-key=$MINIO_ACCESS_KEY
        hive.s3.aws-secret-key=$MINIO_SECRET_KEY
        hive.s3.path-style-access=true
        hive.s3.endpoint=$MINIO_ENDPOINT
        hive.s3.ssl.enabled=false
EOT


  git clone "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${USER}/${REPO}.git"
  cd "$REPO" || exit 0
  git checkout "$TARGET_BRANCH"

  helm upgrade --install "$RELEASE_NAME" urbanos/urban-os   \
    --namespace="$NAMESPACE" \
    --values="$VALUES_FILE_FROM_REPO_ROOT" \
    --values=hive_catalog.yaml \
    {{ if .Values.global.objectStore.accessKey }} --set global.objectStore.accessKey=$MINIO_ACCESS_KEY {{ end -}}\
    {{ if .Values.global.objectStore.accessSecret }} --set global.objectStore.accessSecret=$MINIO_SECRET_KEY {{ end -}}\
    {{ if .Values.raptor.auth.auth0_client_secret }} --set raptor.auth.auth0_client_secret=$RAPTOR_SECRET_KEY {{ end -}}\
    {{ if .Values.discovery-api.secrets.discoveryApiPresignKey }} --set discovery-api.secrets.discoveryApiPresignKey=$API_PRESIGN_KEY {{ end -}}\
    {{ if .Values.discovery-api.secrets.guardianSecretKey }} --set discovery-api.secrets.guardianSecretKey=$API_GUARDIAN_KEY {{ end -}}\
    {{ if .Values.discovery-api.postgres.password }} --set discovery-api.postgres.password=$POSTGRES_PASS {{ end -}}\
    {{ if .Values.andi.postgres.password }} --set andi.postgres.password=$POSTGRES_PASS {{ end -}}\
    {{ if .Values.andi.auth.auth0_client_secret }}--set andi.auth.auth0_client_secret=$ANDI_AUTH0_SECRET {{ end -}}\
    {{ if .Values.persistence.metastore.postgres.password }} --set persistence.metastore.postgres.password=$POSTGRES_PASS {{ end -}}

else
  echo "Current deployment SHA matches the SHA of the configured target branch. Skipping deployment."
fi



