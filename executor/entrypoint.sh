#!/bin/bash
set -euo pipefail

DEPLOYMENT_FILE="/home/richie/mcp-ai-home-cluster/configs/deployment.yaml"

echo "===== ENTRYPOINT START ====="
echo "Using deployment file: $DEPLOYMENT_FILE"

if [ ! -f "$DEPLOYMENT_FILE" ]; then
  echo "ERROR: deployment.yaml not found"
  exit 1
fi

# --------------------------------------------------
# Logging helpers
# --------------------------------------------------

log() {
  echo "[ENTRYPOINT] $1"
}

run_cmd() {
  log "RUN: $1"
  eval "$1"
}

# --------------------------------------------------
# Resolve LATEST_BACKUP_FILE
# --------------------------------------------------

BACKUP_DIR="/home/richie/pi-backups"

LATEST_BACKUP_FILE=""

if [ -d "$BACKUP_DIR" ]; then
  LATEST_BACKUP_FILE=$(ls -t "$BACKUP_DIR" 2>/dev/null | head -n 1 || true)
fi

export LATEST_BACKUP_FILE

log "LATEST_BACKUP_FILE=${LATEST_BACKUP_FILE:-NONE}"

# --------------------------------------------------
# Variable expansion helper
# --------------------------------------------------

expand_vars() {
  local raw="$1"
  eval echo "$raw"
}

# --------------------------------------------------
# Iterate actions IN FILE ORDER
# --------------------------------------------------

ACTIONS=$(yq e '.actions | to_entries | .[].key' "$DEPLOYMENT_FILE")

for ACTION in $ACTIONS; do
  log "=== ACTION: $ACTION ==="

  STEP_COUNT=$(yq e ".actions.${ACTION}.steps | length" "$DEPLOYMENT_FILE")

  for ((i=0; i<STEP_COUNT; i++)); do

    TYPE=$(yq e ".actions.${ACTION}.steps[$i].type" "$DEPLOYMENT_FILE")

    log "Step $((i+1)) / $STEP_COUNT → $TYPE"

    case "$TYPE" in

      docker_network)
        NAME=$(yq e ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")
        docker network inspect "$NAME" >/dev/null 2>&1 || \
          run_cmd "docker network create $NAME"
        ;;

      docker_volume)
        NAME=$(yq e ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")
        docker volume inspect "$NAME" >/dev/null 2>&1 || \
          run_cmd "docker volume create $NAME"
        ;;

      docker_pull)
        IMAGE=$(yq e ".actions.${ACTION}.steps[$i].image" "$DEPLOYMENT_FILE")
        run_cmd "docker pull $IMAGE"
        ;;

      compose_up)
        PROJECT=$(yq e ".actions.${ACTION}.steps[$i].project_name" "$DEPLOYMENT_FILE")
        FILE=$(yq e ".actions.${ACTION}.steps[$i].compose_file" "$DEPLOYMENT_FILE")
        DETACHED=$(yq e ".actions.${ACTION}.steps[$i].detached" "$DEPLOYMENT_FILE")

        CMD="docker compose -p $PROJECT -f $FILE up"
        [ "$DETACHED" = "true" ] && CMD="$CMD -d"

        run_cmd "$CMD"
        ;;

      docker_run)
        IMAGE=$(yq e ".actions.${ACTION}.steps[$i].image" "$DEPLOYMENT_FILE")
        NAME=$(yq e ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")
        NETWORK=$(yq e ".actions.${ACTION}.steps[$i].network" "$DEPLOYMENT_FILE")
        RESTART=$(yq e ".actions.${ACTION}.steps[$i].restart" "$DEPLOYMENT_FILE")

        PORT_ARGS=""
        VOLUME_ARGS=""

        for p in $(yq e ".actions.${ACTION}.steps[$i].ports[]" "$DEPLOYMENT_FILE" 2>/dev/null || true); do
          PORT_ARGS+=" -p $p"
        done

        for v in $(yq e ".actions.${ACTION}.steps[$i].volumes[]" "$DEPLOYMENT_FILE" 2>/dev/null || true); do
          VOLUME_ARGS+=" -v $v"
        done

        docker rm -f "$NAME" >/dev/null 2>&1 || true

        CMD="docker run -d --name $NAME --network $NETWORK"
        [ "$RESTART" != "null" ] && CMD+=" --restart $RESTART"

        CMD="$CMD $PORT_ARGS $VOLUME_ARGS $IMAGE"

        run_cmd "$CMD"
        ;;

      docker_exec)
        CONTAINER=$(yq e ".actions.${ACTION}.steps[$i].container" "$DEPLOYMENT_FILE")

        COMMANDS=$(yq e ".actions.${ACTION}.steps[$i].command[]" "$DEPLOYMENT_FILE" 2>/dev/null || \
                   yq e ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")

        for RAW in $COMMANDS; do
          CMD=$(expand_vars "$RAW")
          run_cmd "$CMD"
        done
        ;;

      firewall)
        for PORT in $(yq e ".actions.${ACTION}.steps[$i].ports[]" "$DEPLOYMENT_FILE"); do
          run_cmd "sudo ufw allow $PORT"
        done
        ;;

      container_check)
        for NAME in $(yq e ".actions.${ACTION}.steps[$i].names[]" "$DEPLOYMENT_FILE"); do
          log "Checking container $NAME"

          docker inspect -f '{{.State.Running}}' "$NAME" | grep true >/dev/null \
            || { echo "Container $NAME is NOT running"; exit 1; }
        done
        ;;

      shell)
        RAW=$(yq e ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")
        CMD=$(expand_vars "$RAW")
        run_cmd "$CMD"
        ;;

      cron)
        NAME=$(yq e ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")
        SCHEDULE=$(yq e ".actions.${ACTION}.steps[$i].schedule" "$DEPLOYMENT_FILE")
        COMMAND=$(yq e ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")

        log "Installing cron job: $NAME"

        (crontab -l 2>/dev/null | grep -v "$NAME"; \
         echo "$SCHEDULE $COMMAND # $NAME") | crontab -
        ;;

      *)
        echo "ERROR: Unknown step type: $TYPE"
        exit 1
        ;;
    esac

  done
done

echo "===== ENTRYPOINT COMPLETE ====="
echo "All actions completed successfully."
