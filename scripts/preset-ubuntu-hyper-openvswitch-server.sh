#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=server,openvswitch_mode=regular,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,openvswitch,openvswitch_bridges,hyper_kvm,hyper_lxd,download-images;download_group=iso,post-cleanup"
