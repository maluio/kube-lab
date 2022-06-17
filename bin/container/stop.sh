#!/usr/bin/env bash

CONTAINER_NAME=kube-lab

# Delete all provisioned servers
$(echo "${COMMAND:=docker}") exec "$CONTAINER_NAME" ap playbooks/destroy.yml

# Delete container
$(echo "${COMMAND:=docker}") rm --force "$CONTAINER_NAME"
