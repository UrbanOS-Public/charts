#!/bin/sh

APP_NAME=reaper
REPOSITORY=smartcitiesdata/$APP_NAME
TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPOSITORY:pull" | jq -r .token)
echo "TOKEN:"
echo $TOKEN
REMOTE_DIGEST=$(curl -s -D - -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/development | grep docker-content-digest | cut -d ' ' -f 2 | tr -d '[:space:]')
echo "REMOTE_DIGEST:"
echo $REMOTE_DIGEST
echo ${#REMOTE_DIGEST}

LOCAL_APP_PODS=$(kubectl get pods | grep reaper | cut -d ' ' -f 1)
echo "LOCAL_APP_PODS:"
echo $LOCAL_APP_PODS

for pod in ${LOCAL_APP_PODS[@]}; do
  LOCAL_DIGEST=$(kubectl get pod --namespace=dev $pod -o json | jq '.status.containerStatuses[] | .imageID ' | cut -d '@' -f 2 | sed 's/"//g' | tr -d '[:space:]')
  echo "LOCAL_DIGEST:"
  echo $LOCAL_DIGEST
  echo ${#LOCAL_DIGEST}
  if [ "$LOCAL_DIGEST" = "$REMOTE_DIGEST" ]; then
    echo "$pod has matching digest"
  else
    kubectl rollout restart deployment/$APP_NAME
  fi
done