#!/usr/bin/env bash

IMAGE_NAME=kube-lab

"${COMMAND:=docker}" build -t "$IMAGE_NAME" .
