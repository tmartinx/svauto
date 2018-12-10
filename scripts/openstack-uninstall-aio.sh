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

ifdown br-ex
ifdown dummy0
ifdown dummy1

rm /etc/network/interfaces.d/br-ex.cfg
rm /etc/network/interfaces.d/dummy*

apt purge -y \
	mysql-common \
	rabbitmq-server \
	memcached \
	keystone \
	haproxy \
	dnsmasq-base \
	"glance-*" \
	"nova-*" \
	"neutron-*" \
	"cinder-*" \
	"heat-*" \
	"openstack-*" \
	"manila-*" \
	"openvswitch-*" \
	"gnocchi-*" \
	"ceilometer-*" \
	"aodh-*" \
	"senlin-*" \
	"designate-*" \
	"libvirt*" \
	"qemu*"

apt autoremove -y

dpkg -P `dpkg -l | grep ^rc | awk $'{print $2}' | xargs`

rm -rf /etc/mysql /etc/rabbitmq /etc/memcached.conf /etc/openstack-dashboard /etc/keystone /etc/glance /etc/neutron /etc/nova /etc/heat /etc/cinder /var/lib/mysql* /var/lib/nova /var/lib/glance /var/lib/keystone /var/lib/heat /var/lib/neutron /var/lib/cinder /var/lib/manila /var/lib/openvswitch /var/log/neutron /var/log/nova /var/log/glance /var/log/cinder /var/log/manila /var/lib/openstack-dashboard /usr/share/openstack-dashboard /usr/lib/python2.7/dist-packages/horizon/static/horizon/lib/jquery /var/lib/rabbitmq /var/lib/haproxy /var/lib/libvirt /etc/libvirt/qemu

dpkg --configure -a

apt -f install

rmmod openvswitch

iptables -F
iptables -X
iptables -F -t nat
iptables -X -t nat
