#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=desktop,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf,ubuntu-desktop,ssh_keypair,google-chrome,post-cleanup"
