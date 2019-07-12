#!/usr/bin/env bash

chart="${1:?CHART NAME REQUIRED}"

helm dependency update $chart
helm package $chart --destination docs
helm repo index docs
