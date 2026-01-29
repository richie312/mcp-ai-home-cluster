#!/bin/bash
set -euo pipefail

set -a
source /home/richie/private-secrets/common_infra/.env
set +a

DEPLOYMENT_FILE="/home/richie/mcp-ai-home-cluster/configs/deployment.yaml"

echo "===== ENTRYPOINT START ====="
echo "Using deployment file: $DEPLOYMENT_FILE"

if [ ! -f "$DEPLOYMENT_FILE" ]; then
  echo "ERROR: deployment.yaml not found"
  exit 1
fi

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
  echo "[ENTRYPOINT] $1"
}

run_cmd() {
  log "RUN: $1"
  eval "$1"
}

clean() {
  echo "$1" | sed 's/^"//; s/"$//'
}

# --------------------------------------------------
# Iterate actions in YAML order
# --------------------------------------------------

ACTIONS=$(yq '.actions | keys | .[]' "$DEPLOYMENT_FILE")

for ACTION in $ACTIONS; do
  log "=== ACTION: $ACTION ==="

  STEP_COUNT=$(yq ".actions.${ACTION}.steps | length // 0" "$DEPLOYMENT_FILE")

  for ((i=0; i<STEP_COUNT; i++)); do
    TYPE=$(clean "$(yq ".actions.${ACTION}.steps[$i].type" "$DEPLOYMENT_FILE")")

    log "Step $((i+1)) / $STEP_COUNT → $TYPE"

    case "$TYPE" in

      docker_network)
        NAME=$(clean "$(yq ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")")
        docker network inspect "$NAME" >/dev/null 2>&1 || \
          run_cmd "docker network create $NAME"
        ;;

      docker_volume)
        NAME=$(clean "$(yq ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")")
        docker volume inspect "$NAME" >/dev/null 2>&1 || \
          run_cmd "docker volume create $NAME"
        ;;

      git_clone)
        REPO_URL=$(clean "$(yq ".actions.${ACTION}.steps[$i].repo" "$DEPLOYMENT_FILE")")
        DEST_DIR=$(clean "$(yq ".actions.${ACTION}.steps[$i].dest" "$DEPLOYMENT_FILE")")

        log "Cloning repo $REPO_URL → $DEST_DIR"

        if [ -d "$DEST_DIR/.git" ]; then
          log "Repo exists → pulling latest"
          run_cmd "cd $DEST_DIR && git fetch origin && git checkout main && git pull origin main"
        else
          run_cmd "git clone $REPO_URL $DEST_DIR"
        fi
        ;;

      compose_up)
        PROJECT=$(clean "$(yq ".actions.${ACTION}.steps[$i].project_name" "$DEPLOYMENT_FILE")")
        FILE=$(clean "$(yq ".actions.${ACTION}.steps[$i].compose_file" "$DEPLOYMENT_FILE")")
        DETACHED=$(clean "$(yq ".actions.${ACTION}.steps[$i].detached" "$DEPLOYMENT_FILE")")

        CMD="docker compose -p $PROJECT -f $FILE up"

        if [ "$DETACHED" = "true" ]; then
          CMD="$CMD -d"
        fi

        run_cmd "$CMD"
        ;;

      docker_run)
        IMAGE=$(clean "$(yq ".actions.${ACTION}.steps[$i].image" "$DEPLOYMENT_FILE")")
        NAME=$(clean "$(yq ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")")
        NETWORK=$(clean "$(yq ".actions.${ACTION}.steps[$i].network" "$DEPLOYMENT_FILE")")
        RESTART=$(clean "$(yq ".actions.${ACTION}.steps[$i].restart" "$DEPLOYMENT_FILE")")

        PORT_ARGS=""
        VOLUME_ARGS=""

        PORTS=$(yq ".actions.${ACTION}.steps[$i].ports[]" "$DEPLOYMENT_FILE" 2>/dev/null || true)
        for PORT in $PORTS; do
          CLEAN_PORT=$(clean "$PORT")
          PORT_ARGS="$PORT_ARGS -p $CLEAN_PORT"
        done

        VOLUMES=$(yq ".actions.${ACTION}.steps[$i].volumes[]" "$DEPLOYMENT_FILE" 2>/dev/null || true)
        for VOLUME in $VOLUMES; do
          CLEAN_VOL=$(clean "$VOLUME")
          VOLUME_ARGS="$VOLUME_ARGS -v $CLEAN_VOL"
        done

        CMD="docker run -d --name $NAME --network $NETWORK $PORT_ARGS $VOLUME_ARGS"

        if [ "$RESTART" != "null" ]; then
          CMD="$CMD --restart $RESTART"
        fi

        CMD="$CMD $IMAGE"

        docker rm -f "$NAME" >/dev/null 2>&1 || true
        run_cmd "$CMD"
        ;;

      shell)
        CMD=$(yq -r ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")

        log "Running shell step..."

        set +u
        bash -c "$CMD"
        RC=$?
        set -u

        if [ $RC -ne 0 ]; then
          echo "ERROR: shell step failed"
          exit 1
        fi
        ;;

      docker_exec)
        if [[ -n "$STDIN_FILE" ]]; then
          run_cmd docker exec -i "$CONTAINER" bash -c "$CMD" < "$STDIN_FILE"
        else
          run_cmd docker exec -i "$CONTAINER" bash -c "$CMD"
        fi
        STDIN_FILE=$(clean "$(yq ".actions.${ACTION}.steps[$i].stdin_file" "$DEPLOYMENT_FILE")")
        CONTAINER=$(clean "$(yq ".actions.${ACTION}.steps[$i].container" "$DEPLOYMENT_FILE")")
        CMD=$(clean "$(yq ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")")

        log "Exec inside $CONTAINER → $CMD"

        run_cmd docker exec -i "$CONTAINER" bash -c "$CMD"
        ;;

      firewall)
        PORTS=$(yq ".actions.${ACTION}.steps[$i].ports[]" "$DEPLOYMENT_FILE")

        for PORT in $PORTS; do
          CLEAN_PORT=$(clean "$PORT")
          run_cmd "sudo ufw allow $CLEAN_PORT"
        done
        ;;

      container_check)
        NAMES=$(yq ".actions.${ACTION}.steps[$i].names[]" "$DEPLOYMENT_FILE")

        for NAME in $NAMES; do
          CLEAN_NAME=$(clean "$NAME")
          log "Checking container $CLEAN_NAME"
          docker inspect -f '{{.State.Running}}' "$CLEAN_NAME" | grep true >/dev/null \
            || { echo "Container $CLEAN_NAME is NOT running"; exit 1; }
        done
        ;;

      cron)
        NAME=$(clean "$(yq ".actions.${ACTION}.steps[$i].name" "$DEPLOYMENT_FILE")")
        SCHEDULE=$(clean "$(yq ".actions.${ACTION}.steps[$i].schedule" "$DEPLOYMENT_FILE")")
        COMMAND=$(clean "$(yq ".actions.${ACTION}.steps[$i].command" "$DEPLOYMENT_FILE")")

        SCHEDULE=$(echo "$SCHEDULE" | tr -d '\n')

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
