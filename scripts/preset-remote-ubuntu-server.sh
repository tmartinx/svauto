#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,192.168.0.10,ansible_user=root,mode=server,os_release=rocky" \
	--ansible-playbook-builder="all,bootstrap;os=ubuntu;base_os_upgrade=true,ssh_keypair,post-cleanup"
