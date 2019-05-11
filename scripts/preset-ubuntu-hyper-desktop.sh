#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=desktop,os_release=rocky" \
        --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub,ubuntu-desktop,ssh_keypair,vagrant,os_clients,google-chrome,ubuntu-virt;setup=host,lxd;setup=host,virtualbox,download-images,post-cleanup"
