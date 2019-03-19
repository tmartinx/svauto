#! /bin/bash

curl -s https://github.com/tmartinx/svauto/raw/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --ansible-inventory-builder="all,localhost,ansible_connection=local" --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf" --ansible-extra-vars="dba_service_ip=1.1.1.1,cluster_name=custom"
