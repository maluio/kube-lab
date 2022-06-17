#!/usr/bin/env bash

rm -rf ~/.kube
mkdir ~/.kube

$(echo "${COMMAND:=nerdctl}") cp kube-lab:/root/.kube/config ~/.kube/config
