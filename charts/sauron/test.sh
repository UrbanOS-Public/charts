#!/bin/sh
# shellcheck disable=SC2039
# shellcheck disable=SC2039

image_auto_update() {
  APP_NAME=$1
  echo "APP_NAME:"
  echo "$APP_NAME \n"

  REPOSITORY=smartcitiesdata/$APP_NAME
  echo "REPOSITORY:"
  echo "$REPOSITORY \n"

  MAJOR=$2
  echo "MAJOR:"
  echo "$MAJOR \n"

  MINOR=$3
  echo "MINOR:"
  echo "$MINOR \n"

  # Replace _ with - to conform to kubernetes standards
  KUBERNETES_FORMATTED_APP_NAME=${APP_NAME//_/-}
  
  POD_NAME=$(kubectl get pods | grep -m1 "$KUBERNETES_FORMATTED_APP_NAME" | cut -d ' ' -f 1)
  echo "POD_NAME:"
  echo "$POD_NAME \n"

  POD_IMAGE_TAG=$(kubectl get pod --namespace=dev "$POD_NAME" -o json | jq '.status.containerStatuses[] | .image ' | cut -d ':' -f 2 | sed 's/"//g' | tr -d '[:space:]')
  echo "POD_IMAGE_TAG:"
  echo "$POD_IMAGE_TAG"


  if [[ $POD_IMAGE_TAG == "development" ]]; then

    TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPOSITORY:pull" | jq -r .token)
    echo "TOKEN Length: ${#TOKEN}"

    ALL_TAGS=$(curl --location --request GET "https://hub.docker.com/v2/namespaces/smartcitiesdata/repositories/$APP_NAME/tags" | jq '.results | map(.name)')
    echo "ALL TAGS:"
    echo "$ALL_TAGS \n"

    MATCHED_TAGS=$(echo "$ALL_TAGS" | jq "map(match(\"$MAJOR\\\.$MINOR\\\.([0-9]+)\"))")
    VALID_TAGS=$(echo "$MATCHED_TAGS" | jq "map(.string)")
    echo "VALID_TAGS:"
    echo "$VALID_TAGS \n"

    LATEST_PATCH_VERSION=$(echo "$MATCHED_TAGS" | jq "map(.captures) | flatten(1) | map(.string | tonumber) | max")
    echo "LATEST_PATCH_VERSION:"
    echo "$LATEST_PATCH_VERSION \n"

    TARGET_REMOTE_DIGEST=$(curl -s -D - -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/$MAJOR.$MINOR.$LATEST_PATCH_VERSION | grep docker-content-digest | cut -d ' ' -f 2 | tr -d '[:space:]')
    echo "TARGET_REMOTE_DIGEST:"
    echo "$TARGET_REMOTE_DIGEST"
    echo "Length: ${#TARGET_REMOTE_DIGEST} \n"

    DEVELOPMENT_REMOTE_DIGEST=$(curl -s -D - -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/development | grep docker-content-digest | cut -d ' ' -f 2 | tr -d '[:space:]')
    echo "DEVELOPMENT_REMOTE_DIGEST:"
    echo "$DEVELOPMENT_REMOTE_DIGEST"
    echo "Length: ${#DEVELOPMENT_REMOTE_DIGEST} \n"

    CURRENT_DIGEST=$(kubectl get pod --namespace=dev $POD_NAME -o json | jq '.status.containerStatuses[] | .imageID ' | cut -d '@' -f 2 | sed 's/"//g' | tr -d '[:space:]')
    echo "CURRENT_DIGEST:"
    echo "$CURRENT_DIGEST"
    echo "Length: ${#CURRENT_DIGEST} \n"

    if [[ $CURRENT_DIGEST != "$DEVELOPMENT_REMOTE_DIGEST" ]]; then
      echo "Pod $POD_NAME is not up-to-date."
      if [[ $TARGET_REMOTE_DIGEST == "$DEVELOPMENT_REMOTE_DIGEST" ]]; then
        echo "Newest patch of this Major/Minor matches development. Restarting deployment to trigger update"
        DEPLOYMENT_NAME=$(kubectl get deployments | grep -m1 "$APP_NAME" | cut -d ' ' -f 1)
        echo "DEPLOYMENT_NAME:"
        echo "$DEPLOYMENT_NAME \n"

        kubectl rollout restart "deployment/$DEPLOYMENT_NAME"
      else
        echo "Latest patch version does not match development. This most likely means development has had a major/minor version update."
        echo "Major/Minor updates indicate a chart value change. Please adjust your deployment manually and update the Major/Minor for this auto-updater pod."
        echo "Skipping deployment restart."
      fi
    else
      echo "Pod $POD_NAME is already updated to development."
      echo "Skipping deployment restart."
    fi

  else

    echo "Pod $POD_NAME is not running development tag. Skipping docker image auto-updates."
  fi
}

image_auto_update discovery_streams 3 0




