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


  git clone "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${USER}/${REPO}.git"
  cd "$REPO" || exit 0
  git checkout "$TARGET_BRANCH"





fi



