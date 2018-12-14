
# SVAuto - The Save Automation

# Ansible Playbooks for OpenStack

Ansible playbooks for deploying `OpenStack`.  http://openstack.org

## Overview

To deploy OpenStack with SVAuto, in your local machine, you'll need to first, follow the instructions on [README.md](README.md), about bootstrapping an Ubuntu Machine, script `./scripts/preset-ubuntu-[server|desktop]`.

Then you'll have a fully upgraded `Ubuntu Bionic`, ready for deploying `OpenStack` on top of it!

SVAuto's `Ansible` playbooks provides two ways for deploying `OpenStack`, first and quick mode, is by running it on your local machine by using one of the "Preset Scripts" `~/svauto/scripts`, the second mode is a advanced, where you'll be deploying `OpenStack` on remote computers, from your SVAuto's machine (actually, your "Ansible Server").

This procedure will deploy `OpenStack` in your local machine, in a fashion called `all-in-one`. It follows `OpenStack` official documentation `https://docs.openstack.org`.

SVAuto supports deploying OpenStack Neutron with the following network options:

- Linux Bridges - Neutron Agents required (default, easier to debug and understand the concepts);

- OpenvSwitch - Neutron Agents required

- OpenvSwitch OVN - Neutron Agents NOT required!

*NOTE: The Neutron Agents, depending on the number of L3 Routers and DHCP Agents, creates a huge number of Linux Namespaces at the Network Nodes, so, the `reboot` of a machine with Neutron Agents, might take a while to be restarted. That's why OpenvSwitch with OVN is so awesome! No more Neutron Agents (just the Server).*

SVAuto also supports multi-node OpenStack deployments, with both Linux Bridges and OpenvSwitch. The support for multi-region with central Horizon is coming!

For the `multi-node` deployments, `OpenvSwitch` is recommended, specially if you're planning to run NFV Apps (like an Instance running a L2 Bridge in between two VXLAN networks, let's say, for DPI) inside of your Cloud. NFV's are also hungry for high performance networks, when `OpenvSwitch` with `DPDK` might be a good fit!

Another awesome SVAuto's feature, is that it have a few, but cool, Heat templates, ready to go!

SVAuto's Heat Templates are located here `svauto/misc/os-heat-templates`.

Support for Nova Compute LXD coming!

## Some requirements

A- A fresh installation of `Ubuntu Bionic` bootstrapped by SVAuto as per [README.md](README.md), the "Preset scripts";

B- Your `/etc/hostname` file must contains ONLY the hostname itself, not the FQDN.

C- Your `IP + FQDN + hostname + aliases` should be configured in your `/etc/hosts` file.

## 1- Deploy OpenStack Rocky with SVAuto

There are 4 predefined options to deploy OpenStack with SVauto, a minimal option and a "full" option. Both supports Linux Bridges and OpenvSwitch.

The Preset Scripts are located under `svauto/scripts/preset-os-rocky*`. 

Go to SVAuto subdir, like:

    cd ~/svauto

...to run the Preset Scripts on next step..

### OpenStack Minimal

It includes the Keystone, Glance, Nova, Neutron and a few extras, like Horizon and Heat.

OpenStack with Linux Bridges:

    ./scripts/preset-os-rocky-mini-lbr-aio.sh

OpenStack with OpenvSwitch:

    ./scripts/preset-os-rocky-mini-ovs-aio.sh

### OpenStack "Full"

This deployment option includes the Minimal, plus, more OpenStack Components, like Cinder, Manila, Senlin and its Dashboard, AODH, Gnocchi, Ceilometer, Designate and a few more to come.

OpenStack with OpenvSwitch:

    ./scripts/preset-os-rocky-full-ovs-aio.sh

OpenStack with OpenvSwitch:

    ./scripts/preset-os-rocky-full-ovs-aio.sh

*NOTE: Support for multi-node OpenStack deployments is basically ready, a Preset Script for it is coming.

WELL DONE!!!

Now, you shoud have OpenStack Rocky up and running!

*TODO: Document how to use OpenStack CLI and the Heat templates!*

# Extra Information

1- The the following entries are required to your `/etc/network/interfaces` file:

    # Fake External Interface
    allow-hotplug dummy0
    iface dummy0 inet static
      address 172.31.254.129
      netmask 25

    # VXLAN Data Path
    allow-hotplug dummy1
    iface dummy1 inet static
      mtu 1550
      address 10.0.0.1
      netmask 24

*NOTE: SVAuto will create those files for you! When called via OpenStack's Preset Scripts. The Dummy interfaces managed by Ansible are hardcoded for now*

*NOTE: The systemd-networkd support and/or Netplan is under the radar.
