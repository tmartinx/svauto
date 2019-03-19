#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=server,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf,ssh_keypair,post-cleanup"
