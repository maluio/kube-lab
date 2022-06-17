#!/usr/bin/env bash

cd "$PROJ_PATH" || exit 1
ansible-playbook -i playbooks/hcloud.yml playbooks/create.yml
ansible-playbook -i playbooks/hcloud.yml playbooks/post_create.yml

cd "$KUBESPRAY_PATH" || exit 1
ansible-playbook -i "$PROJ_PATH"/mycluster cluster.yml -b

cd "$PROJ_PATH" || exit 1
ansible-playbook -i playbooks/hcloud.yml playbooks/post_deploy.yml
