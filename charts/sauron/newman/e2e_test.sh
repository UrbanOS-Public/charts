#!/bin/bash

echo "STARTING E2E TESTS"

# setup
newman run e2e_test.postman_collection.json --insecure --delay-request 2000 \
    --reporters json --reporter-json-export results.json

FAILURES=$(jq .run.stats.assertions.failed results.json)

echo "E2E TEST FAILURES:" $FAILURES
