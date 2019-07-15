#!/usr/bin/env bash

chart="${1:?CHART NAME REQUIRED}"
version="${2:?VERSION REQUIRED}"

helm dependency update $chart
helm package $chart --version $version --destination docs
helm repo index docs
