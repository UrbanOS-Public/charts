#!/bin/bash

OUTPUT_DIR=$1
if [[ $OUTPUT_DIR == "" ]]; then
  echo "Empty output location. Please provide an output location when running this script. EX: ./e2e_tests.sh /sauron"
  exit 1
fi

NORMALIZED_OUTPUT_DIR=$(dirname "$OUTPUT_DIR")/$(basename "$OUTPUT_DIR")

OUTPUT_FILE="$NORMALIZED_OUTPUT_DIR/results.json"
OUTPUT_ERROR_FILE="$NORMALIZED_OUTPUT_DIR/$(date +%s)_errors.json"
echo "Results Output File: $OUTPUT_FILE"
echo "Error Output File: $OUTPUT_ERROR_FILE"

echo "STARTING E2E TESTS"

# setup
newman run e2e_test.postman_collection.json --insecure --delay-request 2000 \
    --reporters json --reporter-json-export "$OUTPUT_FILE"

FAILURES=$(jq .run.stats.assertions.failed "$OUTPUT_FILE")
if [[ $FAILURES -gt 0 ]]; then
  cat "$OUTPUT_FILE" | jq '.run.executions | map(.assertions) | flatten(2) | map(select(.error != null))' > $OUTPUT_ERROR_FILE

  cat "$OUTPUT_ERROR_FILE"
  echo "E2E TEST FAILURES: $FAILURES"
else
  echo "All E2E Tests Passed!"
fi


