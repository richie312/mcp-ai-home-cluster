#!/bin/bash

set -e

ACTION=$1
shift

PARAMS="$@"

YAML_FILE="/executor/deployment.yaml"
ENV_FILE="/executor/runtime.env"

# Load environment variables if present
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from $ENV_FILE"
  export $(grep -v '^#' $ENV_FILE | xargs)
else
  echo "WARNING: runtime.env not found, continuing without custom env"
fi

if [ -z "$ACTION" ]; then
  echo "ERROR: No action provided"
  exit 1
fi

echo "Executor started for action: $ACTION"

SCRIPT=$(yq e ".actions.$ACTION.script" $YAML_FILE)

if [ "$SCRIPT" == "null" ] || [ -z "$SCRIPT" ]; then
  echo "ERROR: Action '$ACTION' not found in deployment.yaml"
  exit 1
fi

echo "$SCRIPT" > /tmp/action.sh
chmod +x /tmp/action.sh

bash /tmp/action.sh $PARAMS

exit $?
