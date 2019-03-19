#! /bin/bash

curl -s https://github.com/tmartinx/svauto/raw/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu18 --ansible-inventory-builder="all,localhost,ansible_connection=local" --ansible-playbook-builder="localhost,bootstrap"
