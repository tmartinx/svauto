#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=desktop,openvswitch_mode=regular,os_release=rocky" \
        --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub,ubuntu-desktop,ssh_keypair,vagrant,os_clients,google-chrome,openvswitch,openvswitch_bridges,ubuntu-virt;setup=host,lxd;setup=host,virtualbox,download-images,post-cleanup"
