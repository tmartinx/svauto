# Ansible Playbook for OpenStack

# svauto

Ansible playbooks for deploying `OpenStack`.  http://openstack.org

# Overview

You'll need an `Ubuntu Xenial` up and running, fully upgraded, before deploying `OpenStack` on top of it.

Our `Ansible` playbooks provides two ways to deploy `OpenStack`, first and quick mode, is by running it on your local computer, the second mode is a bit more advanced, where you'll be deploying `OpenStack` on remote computers.

This procedure will deploy `OpenStack` (bare metal highly recommended, server or laptop) in a fashion called `all-in-one`. It follows `OpenStack` official documentation `docs.openstack.org`.

The `default` setup builds an `all-in-one` environment, it might be used mostly for demonstration purposes. Only a few environments can use this topology in production.

To begin with, and to reduce the learning curve, we're using `Linux Bridges`, instead of `Open vSwitch`. Because it is very easy to fully understand `OpenStack Neutron` internals with `Linux Bridges`, it is easier to debug and simpler (`KISS Principle`).

Nevertheless, for a future `multi-node` deployments, `Open vSwitch` will be preferred. Specially for higly performance networks, when we'll be using `Open vSwitch` with `DPDK`.

In the next version of our `Ansible` playbooks, `Open vSwitch` will be supported for the `default` `all-in-one` deployments.

## Before start, keep in mind that:

A- A fresh installation and fully upgraded `Ubuntu Xenial` is required.

B- Make sure you can use `sudo` without password.

C- Your `/etc/hostname` file must contains ONLY the hostname itself, not the FQDN.

D- Your `IP + FQDN + hostname + aliases` should be configured in your `/etc/hosts` file.

# Quick Procedure

## 1- Install Ubuntu 16.04 (Server or Desktop), details:

* Hostname: "queens-1"
* User: "administrative"
* Password: "whatever"

## 2- Upgrade Ubuntu to the latest version, by running:

    sudo apt update
    sudo apt -y full-upgrade
    sudo reboot

## 3- Basic requirements:

Install `curl` and `ssh`:

    sudo apt install ssh curl -y

Allow members of `sudo` group to become `root` without requiring password promt:

    sudo visudo

The line that starts with `%sudo` must contains:

    %sudo   ALL=NOPASSWD:ALL

## 4- Configure /etc/hostname and /etc/hosts files, like this:

One line in `/etc/hostname`:

    queens-1

First two lines of `/etc/hosts` (do not touch IPv6 lines):

    127.0.0.1 localhost.localdomain localhost
    127.0.1.1 queens-1.yourdomain.com queens-1 queens

*NOTE: If you have fixed IP (v4 or v6), you can use it here (recommended).*

Make sure it is working:

    hostname # Must returns ONLY your Hostname, nothing more.
    hostname -d # Must returns ONLY your Domain.
    hostname -f # Must returns your FQDN.
    hostname -i # Must returns your IP (can be 127.0.1.1).
    hostname -a # Must returns your aliases.

## 5- Deploy OpenStack Mitaka

Then, you'll be able to deploy `OpenStack` by running:

    bash <(curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/scripts/os-install-lbr.sh)

Well done!

# Advanced Procedure

1- Add the following entries to your `/etc/network/interfaces` file:

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

*NOTE: Dummy interfaces can be managed by ansible (hardcoded settings)*

## For local deployments:

1- Install Ansible to deploy your `OpenStack`:

    sudo apt -y install git ansible

    git clone -b dev https://github.com/tmartinx/svauto.git

    pushd svauto

    ./svauto.sh --operation-openstack

## For remote deployments:

1- Make sure you can ssh to your servers using key authentication.

2- Install Ansible to deploy your `OpenStack`:

    sudo apt -y install git ansible

    git clone -b dev https://github.com/tmartinx/svauto.git

    pushd svauto

Configure the file `group_vars/all` according to your remote computer.

Pay an extra attention to the templates: `nova.conf`, `cinder.conf` and `ml2_conf.ini`, reconfigure those if required.

Add your remote computer `FQDN` or `IP Address` to the `hosts` file, within group `all-in-one`, for example.

Then, run `Ansible`:

    ansible-playbook site-openstack.yml

**NOTE:** You can take a look at the script `svauto.sh --operation-openstack` to see what needs to be changed before running `Ansible`.

# Extra info

There is a few assumptions here, like for example:

A- Your remote server have its *default / primary* interface named `eth0`, the **my_ip** config option at `nova.conf` and `cinder.conf`;

B- The `br-ex` `Neutron` interface is bridged against the `dummy0` interface (`ml2_conf.ini`), it have the subnet `172.31.254.128/25`, so, it is the *default gateway* of ALL `Neutron Namespaces` of this deployment. Usually, we must use a real interface for `br-ex`, where the IP 172.31.254.129 should be configured in an `Upstream Router`, outside of `OpenStack`, and NOT here, at the `dummy0` interface.

Details:

    http://docs.openstack.org/liberty/install-guide/install/apt/content/ch_basic_environment.html#basics-neutron-networking-network-node

C- Because the `br-ex` is bridged against the `dummy0` interface, you'll need to create a `iptables masquerade` rule, so your `Instances` can reach the Internet through real `eth0`.

Example:

    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

D- The `vxlan` `Neutron` data network, will be created on top of a `dummy1`, it is really fast but, only works for our `all-in-one` deplyments (`ml2_conf.ini`).

TODO:

- Automate the Network Interfaces management with Ansible.

- Create a "setup / install" script, which will prompt some questions for the user, about local / remote setups, to simplify the instructions presented here.
