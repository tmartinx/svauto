#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,mode=desktop,os_release=rocky" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf,ubuntu-virt;setup=host,hyper_lxd,virtualbox,docker,vagrant,amazon_ec2_tools,redhat_tools_ubuntu,os_clients,packer,vsftpd,download-images;download_group=iso;download_ubuntu=true,post-cleanup"
