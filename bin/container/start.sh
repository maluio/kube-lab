#!/usr/bin/env bash

# Starts the container

PROJ_PATH=/usr/src/app
IMAGE_NAME=kube-lab
CONTAINER_NAME=kube-lab
JUPYTER_PORT=8889

echo "Installing git hooks"
echo "python3 bin/git_hooks/ip_addr_mask.py" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

$(echo "${COMMAND:=docker}") run \
-e HCLOUD_TOKEN="$HCLOUD_TOKEN" \
-p 127.0.0.1:"$JUPYTER_PORT":"$JUPYTER_PORT" \
--name "$CONTAINER_NAME" \
-v "$(pwd)":"$PROJ_PATH" \
-d "$IMAGE_NAME"

$(echo "${COMMAND:=docker}") logs -f "$CONTAINER_NAME"
