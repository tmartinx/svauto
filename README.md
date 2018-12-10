
# SVAuto - The Save Automation

SVAuto is an Open Source Automation Tool, it glues together a different set of tools for building immutable servers images (QCoWs, OVAs, VHDs) and for Infrastructure Automation (Servers or Desktops).

With SVAuto, you can create QCoWs, VMDKs, OVAs, and etc, with Packer and Ansible! It uses the official ISO Images as a base.

There is also a preliminary support for Vagrant with Ansible, that uses regular CentOS / Ubuntu boxes hosted on Atlassian.

Looking forward to add support for Linux Containers (systemd-nspawn, LXD and Docker).

It uses the following Open Source projects:

* Ubuntu Bionic 18.04
* systemd 237
* Ansible 2.5
* Packer 1.0.4
* QEmu 2.11
* VirtualBox 5.2
* Vagrant 2.0.2
* Docker 18.06
* LXD 3.0
* Amazon EC2 AMI & API Tools

It contains Ansible Playbooks for Automated deployments of:

* Ubuntu
* CentOS
* OpenStack on Ubuntu LTS

*NOTES:*

*For using Ansible against remore locations, make sure you can ssh to your instances using key authentication.*

*SVAuto was designed for Ubuntu Bionic 18.04 (latest LTS), Server or Desktop. But CentOS is also sypported."

## Downloading

Download SVAuto into your home directory (Designed for Ubuntu LTS):

    cd ~
    git clone https://github.com/tmartinx/svauto

## Install Python Minimal on Ubuntu 18.04

    apt install python-minimal

## Bootstrapping local systems with the "Preset Scripts"

Bootstrap Ubuntu 18.04 Desktop, it upgrades and installs many useful applications, like Google Chrome and etc...

    cd ~/svauto
    ./scripts/preset-bionic-desktop.sh

Bootstrap Ubuntu 18.04 Server, it upgrades and install a few applications for Servers.

    cd ~/svauto
    ./scripts/preset-bionic-server.sh

*NOTE: You can edit those small scripts and add "--dry-run" to svauto.sh line, this way, it doesn't run Ansible against your localhost, it only outputs Ansible's Inventory and Playbook files. Then, you can run "cd ~/svauto/ansible ; ansible-playbook -i ansible-hosts-XXXX ansible-playbook-XXXX.yml" later, if you want.*

## Creating O.S. Images: QCoW, OVAs, VHD, etc 

### Bootstrapping your Ubuntu (Desktop or Server) for SVAuto

To build QCoWs/OVA images with Packer and Ansible, you need to "Bootstrap Ubuntu For SVAuto", so you can take advantage of all SVAuto's features to build O.S. images.

NOTE: The following procedure download a few ISO images from the Internet, and store it under Libvirt's directory.

Ubuntu Desktop

    cd ~/svauto
    ./scripts/preset-svauto-desktop.sh

Ubuntu Server

    cd ~/svauto
    ./scripts/preset-svauto-server.sh

After this, you'll be able to use Packer to build O.S. Images with Ansible!

#### Packer, Baby Steps

To make sure that your Packer installation is good and that you can actually run it and have a RAW Image in the end of the process, lets go baby steps first.

SVAuto comes with bare-minimum Packer Templates, also very minimal Kickstart and Preseed files.

*NOTE: Packer requires root because it runs the KVM binary directly (i.e., not via Libvirt), so, even if you're member of "libvirt" group, you still need to run it as root.*

Building an Ubuntu 18.04 or CentOS 7 RAW Images with just Packer:

    cd ~/svauto
    sudo packer build packer/ubuntu18.yaml

or:

    sudo packer build packer/centos7.yaml

Enable KVM SDL Screen to see what Packer is doing!

Allow local root user to use X Window System:

    xhost local:root

    sudo packer build packer/ubuntu18-gui.yaml

or:

    sudo packer build packer/centos7-gui.yaml

NOTE: The resulting images are created under packer/ubuntu18-tmpl, or packer/centos7-tmpl, or ...

#### Packer and Ansible

Those small Packer Templates tested on previous baby steps, are the base for the rest of "SVAuto Image Factory".

For example: packer/ubuntu18.yaml is the base for packer/ubuntu18-template.yaml, where the "*-template.yaml" is the one actually being used by "svauto.sh".

SVAuto basically glues together Packer and Ansible, under temporaries subdirectories (packer/build-something), it then goes there and runs "packer build" for you.

Building an Ubuntu 18.04 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./packer-build/ubuntu18.sh

Building a CentOS 7 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./packer-build/centos7.sh

*NOTES:*

*Those O.S. Images have Cloud Init support and its file system grows automatically in a Cloud Environment!*

#### SVAuto Local Config File

The local config file is "~/.svauto.conf", it overrides part of "~/svauto/svauto.conf" variables.

If might have the following contents (example):

    SVAUTO_DIR=/home/ubuntu/svauto
    DOCUMENT_ROOT="public_dir"
    DNS_DOMAIN="yourdomain.com"
    SVAUTO_YUM_HOST="ftp.$DNS_DOMAIN"

### Cleaning it up

To remove the temporary files, run:

    cd ~/svauto
    ./svauto.sh --clean-all
