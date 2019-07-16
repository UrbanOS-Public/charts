#!/usr/bin/env bash

chart="${1:?CHART NAME REQUIRED}"

mkdir tmp_charts
helm package $chart -u -d tmp_charts
helm repo index --merge docs/index.yaml tmp_charts

mv tmp_charts/*.tgz docs
mv tmp_charts/index.yaml docs/index.yaml

rm -rf tmp_charts