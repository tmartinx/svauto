#! /bin/bash

./svauto.sh \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=server,openvswitch_mode=regular,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub,openvswitch,openvswitch_bridges,ubuntu-virt;setup=host,hyper_lxd,download-images;download_group=iso,post-cleanup"
