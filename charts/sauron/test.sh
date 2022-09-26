#!/bin/sh
# shellcheck disable=SC2039
# shellcheck disable=SC2039

image_auto_update() {
  APP_NAME=$1
  echo "APP_NAME:"
  printf "%s \n\n" "$APP_NAME"

  REPOSITORY=smartcitiesdata/$APP_NAME
  echo "REPOSITORY:"
  printf "%s \n\n" "$REPOSITORY"

  MAJOR=$2
  echo "MAJOR:"
  printf "%s \n\n" "$MAJOR"

  MINOR=$3
  echo "MINOR:"
  printf "%s \n\n" "$MINOR"

  # Replace _ with - to conform to kubernetes standards
  KUBERNETES_FORMATTED_APP_NAME=${APP_NAME//_/-}
  
  POD_NAME=$(kubectl get pods | grep -m1 "$KUBERNETES_FORMATTED_APP_NAME" | cut -d ' ' -f 1)
  echo "POD_NAME:"
  printf "%s \n\n" "$POD_NAME"

  POD_IMAGE_TAG=$(kubectl get pod --namespace=dev "$POD_NAME" -o json | jq '.status.containerStatuses[] | .image ' | cut -d ':' -f 2 | sed 's/"//g' | tr -d '[:space:]')
  echo "POD_IMAGE_TAG:"
  printf "%s \n\n" "$POD_IMAGE_TAG"

  if [[ $POD_IMAGE_TAG == "development" ]]; then

    TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPOSITORY:pull" | jq -r .token)
    printf "TOKEN Length: %s \n\n" "${#TOKEN}"

    ALL_TAGS=$(curl --location --request GET "https://hub.docker.com/v2/namespaces/smartcitiesdata/repositories/$APP_NAME/tags" | jq '.results | map(.name)')
    echo "ALL TAGS:"
    printf "%s \n\n" "$ALL_TAGS"

    MATCHED_TAGS=$(echo "$ALL_TAGS" | jq "map(match(\"$MAJOR\\\.$MINOR\\\.([0-9]+)\"))")
    VALID_TAGS=$(echo "$MATCHED_TAGS" | jq "map(.string)")
    echo "VALID_TAGS:"
    printf "%s \n\n" "$VALID_TAGS"

    LATEST_PATCH_VERSION=$(echo "$MATCHED_TAGS" | jq "map(.captures) | flatten(1) | map(.string | tonumber) | max")
    echo "LATEST_PATCH_VERSION:"
    printf "%s \n\n" "$LATEST_PATCH_VERSION"

    TARGET_REMOTE_DIGEST=$(curl -s -D - -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/$MAJOR.$MINOR.$LATEST_PATCH_VERSION | grep docker-content-digest | cut -d ' ' -f 2 | tr -d '[:space:]')
    echo "TARGET_REMOTE_DIGEST:"
    echo "$TARGET_REMOTE_DIGEST"
    printf "Length: %s \n\n" "${#TARGET_REMOTE_DIGEST}"

    DEVELOPMENT_REMOTE_DIGEST=$(curl -s -D - -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/development | grep docker-content-digest | cut -d ' ' -f 2 | tr -d '[:space:]')
    echo "DEVELOPMENT_REMOTE_DIGEST:"
    echo "$DEVELOPMENT_REMOTE_DIGEST"
    printf "Length: %s \n\n" "${#DEVELOPMENT_REMOTE_DIGEST}"

    CURRENT_DIGEST=$(kubectl get pod --namespace=dev $POD_NAME -o json | jq '.status.containerStatuses[] | .imageID ' | cut -d '@' -f 2 | sed 's/"//g' | tr -d '[:space:]')
    echo "CURRENT_DIGEST:"
    echo "$CURRENT_DIGEST"
    printf "Length: %s \n\n" "${#CURRENT_DIGEST}"

    if [[ $CURRENT_DIGEST != "$DEVELOPMENT_REMOTE_DIGEST" ]]; then
      echo "Pod $POD_NAME is not up-to-date."
      if [[ $TARGET_REMOTE_DIGEST == "$DEVELOPMENT_REMOTE_DIGEST" ]]; then
        echo "Newest patch of this Major/Minor matches development. Restarting deployment to trigger update"
        DEPLOYMENT_NAME=$(kubectl get deployments | grep -m1 "$APP_NAME" | cut -d ' ' -f 1)
        echo "DEPLOYMENT_NAME:"
        echo "$DEPLOYMENT_NAME"

        kubectl rollout restart "deployment/$DEPLOYMENT_NAME"
        printf "\n\n\n\n\n"
      else
        echo "Latest patch version does not match development. This most likely means development has had a major/minor version update."
        echo "Major/Minor updates indicate a chart value change. Please adjust your deployment manually and update the Major/Minor for this auto-updater pod."
        echo "Skipping deployment restart."
        printf "\n\n\n\n\n"
      fi
    else
      echo "Pod $POD_NAME is already updated to development."
      echo "Skipping deployment restart."
      printf "\n\n\n\n\n"
    fi

  else
    echo "Pod $POD_NAME is not running development tag. Skipping docker image auto-updates."
    printf "\n\n\n\n\n"
  fi
}

image_auto_update discovery_streams 3 0




