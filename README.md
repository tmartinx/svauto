
# SVAuto - The Save Automation

Because it saves you a lot of time!

SVAuto is an Open Source Automation Tool, it glues together a different set of tools for building immutable servers images (QCoWs, OVAs, VHDs) and for Infrastructure Automation (Servers or Desktops).

With SVAuto, you can create QCoWs, VMDKs, OVAs, and etc, with Packer and Ansible! It uses the official ISO Images as a base.

There is also a preliminary support for Vagrant with Ansible, that uses regular Ubuntu / CentOS boxes hosted on Atlassian.

Looking forward to add support for Linux Containers (systemd-nspawn, LXD and Docker).

SVAuto was designed for Ubuntu Bionic 18.04 (latest LTS), Server or Desktop. But CentOS is also supported.

It uses the following Open Source projects:

* Ubuntu Bionic 18.04
* LXD 3.0
* QEmu 2.11
* systemd 237
* Ansible 2.5
* Packer 1.0.4
* VirtualBox 5.2
* Python 2.7

On SVAuto's radar:

* Netplan
* systemd-networkd
* nftables
* Vagrant 2.0.2
* Docker 18.06
* Amazon EC2 AMI & API Tools
* WireGuard
* Ceph

It contains Ansible Playbooks for Automated deployments of:

* Ubuntu
* CentOS
* OpenStack on Ubuntu LTS

# Quick Procedure

## 1- Install Ubuntu 18.04 (Server or Desktop), let's say with:

- Hostname: "myserver-1"
- User: "ubuntu"
- Password: "whatever"
    
## 2- Hostname and Hosts Basic Configuration

### 2.1- One line in `/etc/hostname` with your host's name:

    myserver-1

### 2.2- First two lines of `/etc/hosts` (leave the rest of your file untouched):

    127.0.0.1 localhost.localdomain localhost
    127.0.1.1 myserver-1.yourdomain.com myserver-1 myserver
 
*NOTE: If you have fixed IP (v4 or v6), you can use it here (recommended), instead of 127.0.1.1. But the default works very well, especially if you're connected via DHCP / WIFI.*

### 2.3- Make sure it is working:

The following `hostname` executions, must returns...

ONLY your Hostname, nothing more:

    hostname

ONLY your Domain:

    hostname -d

ONLY your FQDN:

    hostname -f

127.0.1.1 (or your local IP, if you configured it previsouly:

    hostname -i

Your aliases:

    hostname -a

## 3- Install Python 2 and Git on Ubuntu 18.04

    sudo apt install -y python git

## 4- Downloading SVAuto

To download SVAuto into your home directory, clone it with git, as follows:

    cd ~
    git clone https://github.com/tmartinx/svauto

## 5- The Preset Scripts

With the Preset Scripts, it's super easy to bootstrap a fresh installed Ubuntu, Server or Desktop, with minimal featureset, or for more specific use caes, as a KVM and/or LXD Hypervisor, OpenvSwitch with DPDK, and even deploy OpenStack!

Bootstrap Ubuntu 18.04 Desktop, it upgrades and installs many useful applications, like Google Chrome and etc:

    cd ~/svauto
    ./scripts/preset-ubuntu-desktop.sh

Bootstrap Ubuntu 18.04 Server, it upgrades and install a few applications for Servers:

    cd ~/svauto
    ./scripts/preset-ubuntu-server.sh

The main `svauto.sh` script supports an option called `--dry-run`, which disables the Ansible's Playbook execution. This way, `svauto.sh` only outputs Ansible's Inventiry and Playbooks files under `svauto/ansible` subdir.

Then, you can run Ansible manually, like:

    pushd ~/svauto/ansible
    ansible-playbook -i ansible-hosts-XXXX ansible-playbook-XXXX.yml

## 6- The Image Factory

SVAuto uses Packer with Ansible, to build O.S. images ready for a Cloud Environment.

It's supports the following O.S. Images formats: QCoW2, VMDK, OVA, VHD and RAW. 

### 6.1- Bootstrapping your Ubuntu (Desktop or Server) for SVAuto

To build QCoWs/OVA images with Packer and Ansible, you need to "Bootstrap Ubuntu For SVAuto", so you can take advantage of all SVAuto's features to build O.S. images.

*NOTE: The following procedure download a few ISO images from the Internet, and store it under `/srv/ISO` sub directory.*

Ubuntu Desktop

    cd ~/svauto
    ./scripts/preset-svauto-desktop.sh

Ubuntu Server

    cd ~/svauto
    ./scripts/preset-svauto-server.sh

After this, you'll be able to use Packer to build O.S. Images with Ansible!

### 6.2- Packer, Baby Steps

To make sure that your Packer installation is good and that you can actually run it and have a RAW Image in the end of the process, lets go baby steps first.

SVAuto comes with bare-minimum Packer Templates, also very minimal Preseeds for Ubuntu and Kickstarts for CentOS.

*NOTE: Packer requires `sudo` because it runs KVM directly, not via Libvirt.*

Building O.S. RAW Images with just Packer (no Ansible involved here):

Go to SVAuto's subdir

    cd ~/svauto

Ubuntu 18.04

    sudo packer build packer/ubuntu18.yaml

CentOS 7

    sudo packer build packer/centos7.yaml

To have a better visual about what Packer is doing, you can enable the KVM GUI (SDL-based) screen.

Allow local root user to use X Window System:

    xhost local:root

    sudo packer build packer/ubuntu18-gui.yaml

or:

    sudo packer build packer/centos7-gui.yaml

*NOTE: You can export `PACKER_LOG=1` variable, to enable Packer debug messages.*

*NOTE: The resulting images are created under `packer/ubuntu18-tmpl`, or `packer/centos7-tmpl`...*

### 6.3- Packer and Ansible

Those small Packer Templates tested on previous baby steps, are the base for the rest of "SVAuto Image Factory".

For example: `packer/ubuntu18.yaml` is the base for `packer/ubuntu18-template.yaml`, where the `*-template.yaml` is the one actually being used by `svauto.sh`.

SVAuto basically glues together Packer and Ansible, under temporaries subdirectories (`packer/build-something`), it then goes there and runs `packer build` for you.

Building an Ubuntu 18.04 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./packer-build/ubuntu18.sh

Building a CentOS 7 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./packer-build/centos7.sh

*NOTES:*

*Those O.S. Images have Cloud Init support and its file system grows automatically in a Cloud Environment!*

## 7- SVAuto Local Config File

The local config file is `~/.svauto.conf`, it overrides part of `~/svauto/svauto.conf` variables.

If might have the following contents (example):

    SVAUTO_DIR=/home/ubuntu/svauto
    DOCUMENT_ROOT="public_dir"
    DNS_DOMAIN="yourdomain.com"
    SVAUTO_YUM_HOST="ftp.$DNS_DOMAIN"

## 8- Cleaning it up

To remove the temporary files, run:

    cd ~/svauto
    ./svauto.sh --clean-all

## 9- OpenStack SVAuto

SVAuto supports deploying OpenStack in a very simple way, instructions at the following link:

[OpenStack SVAuto](README.OpenStack.md)
