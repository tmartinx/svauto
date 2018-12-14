#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,192.168.0.10,ansible_user=root,ubuntu_install=server,os_release=rocky" \
	--ansible-playbook-builder="all,bootstrap;os=ubuntu;base_os_upgrade=yes,ssh_keypair,post-cleanup"
