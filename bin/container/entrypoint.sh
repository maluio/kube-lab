#!/usr/bin/env bash

JUPYTER_PORT=8889

export ANSIBLE_HOST_KEY_CHECKING=false

if [[ -z "$HCLOUD_TOKEN" ]]; then
  echo "HCLOUD_TOKEN not set. Aborting..."
  exit 1
fi

cp bin/cluster/ap /usr/local/bin/ap \
    && chmod +x /usr/local/bin/ap \
    && cp bin/cluster/ks /usr/local/bin/ks \
    && chmod +x /usr/local/bin/ks

echo "Starting jupyter server"

jupyter-lab --allow-root --ip=0.0.0.0 --no-browser  --port="$JUPYTER_PORT" --notebook-dir="$PROJ_PATH"/notebooks
