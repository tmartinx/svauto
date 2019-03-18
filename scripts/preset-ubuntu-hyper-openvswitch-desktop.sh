#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=desktop,openvswitch_mode=regular,os_release=rocky" \
        --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf,ubuntu-desktop,ssh_keypair,vagrant,os_clients,google-chrome,openvswitch,openvswitch_bridges,ubuntu-virt;setup=host,hyper_lxd,virtualbox,download-images;download_group=iso;download_ubuntu=true,post-cleanup"
