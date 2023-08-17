#!/bin/bash

if [[ -z "$1" ]]; then
  echo "please provide a playbook yaml file to run"
  exit 1
fi

HOST="${HOST:-local}"

echo "Runing on host $HOST"

ansible-playbook -i inventory.cfg -e "@./playbooks/vars.yml" -l "$HOST" "$1" --ask-vault-pass
