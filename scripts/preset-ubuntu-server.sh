#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=server,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ssh_keypair,post-cleanup"
