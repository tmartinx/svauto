#! /bin/bash

# Copyright 2018, TCMC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO: Only use hard-coded variables, if there are no settings already
# configured on the local system.
UBUNTU_USERNAME="ubuntu"
UBUNTU_HOSTNAME="controller-1"
YOUR_DOMAIN="yourdomain.com"
UBUNTU_PRIMARY_INTERFACE="eth0"
OS_EXTERNAL="dummy0"
OS_DATA="dummy1"

clear

echo
echo "Welcome to SVAuto's OpenStack Rocky deployment!"
echo

echo
echo "Deploying OpenStack..."
echo
echo "Bridge Mode: Open vSwitch"
echo

./svauto.sh --cpu-check --hostname-check \
	--ansible-inventory-builder="os_aio,localhost,ansible_connection=local,regular_system_user=$UBUNTU_USERNAME,os_release=rocky,ubuntu_primary_interface=$UBUNTU_PRIMARY_INTERFACE,os_dns_domain=$YOUR_DOMAIN,os_public_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,os_admin_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,deployment_mode=true,os_mgmt=$UBUNTU_PRIMARY_INTERFACE" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=true,grub-conf,openvswitch;openvswitch_mode=regular,openvswitch_bridges;os_neutron_ovs_enabled=true,ubuntu-network-setup;ubuntu_primary_interface_via_ifupdown=true;ubuntu_setup_dummy_nics=true;ubuntu_enable_ip_masquerade=true,os_manage_etc_hosts,os_clients,ssh_keypair,os_mysql,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,ubuntu-virt;setup=host,os_nova;os_nova_ctrl=true;os_nova_cmpt=true,os_neutron;os_aio=true;os_neutron_ctrl=true;os_neutron_net=true;os_neutron_ovs_enabled=true;neutron_interface_driver=openvswitch;os_external=$OS_EXTERNAL;os_data=$OS_DATA,os_horizon,os_heat,os_senlin,loopback;os_component=os_cinder,os_cinder;os_aio=true;os_cinder_ctrl=true,os_cinder_vol=true,loopback;os_component=os_manila,os_manila;os_aio=true;os_manila_ctrl=true;os_manila_share=true,os_gnocchi,os_ceilometer,os_aodh,os_keypair,os_ext_net,download-images;download_group=cloud,os_glance_images,post-cleanup"
