#!/usr/bin/env bash
set -e

APP=$1
VERSION=$2

helm repo add urbanos https://urbanos-public.github.io/charts/
helm repo update

RESULT=$(helm search repo "urbanos/$APP" --version "$VERSION")

if [[ $RESULT == "No results found" ]]; then
  printf "Version %s has not already been published. Continuing." "$VERSION"
else
  printf "Version %s has already been published. Please bump the chart version if you want to publish. Failing CICD Check." "$VERSION"
  exit 1
fi