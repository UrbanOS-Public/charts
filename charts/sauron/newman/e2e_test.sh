#!/bin/bash

echo "STARTING E2E TESTS"

# safety cleanup in case previous run failed
newman run e2e_test_cleanup.postman_collection.json --insecure --delay-request 2000

# setup
newman run e2e_test_setup.postman_collection.json --insecure --delay-request 2000 \
    --reporters json --reporter-json-export results/setup.json
sleep 10

# get results
newman run e2e_test_discovery_api.postman_collection.json --insecure \
    --reporters json --reporter-json-export results/discovery.json

# cleanup
newman run e2e_test_cleanup.postman_collection.json --insecure --delay-request 2000 \
    --reporters json --reporter-json-export results/cleanup.json

SETUP_FAILURES=$(jq .run.stats.assertions.failed results/setup.json)
DISCOVERY_FAILURES=$(jq .run.stats.assertions.failed results/discovery.json)
CLEANUP_FAILURES=$(jq .run.stats.assertions.failed results/cleanup.json)

echo "SETUP_FAILURES:" $SETUP_FAILURES
echo "DISCOVERY_FAILURES:" $DISCOVERY_FAILURES
echo "CLEANUP_FAILURES:" $CLEANUP_FAILURES

echo "E2E TEST COMPLETE"
