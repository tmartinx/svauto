
TODO: Review it.

## Bootstrapping boxes with "curl pipe bash"

Bootstrap Ubuntu 18.04 Server, configure Grub and clean it up, while upgrading it:

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu18 --ansible-roles=bootstrap,grub-conf,post-cleanup --ansible-extra-vars="base_os_upgrade=yes,ubuntu_install=server"

or:

    bash <(curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/bootstrap-xenial-server.sh) 

    curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/bootstrap-xenial-server.sh | bash

Bootstrap Ubuntu 18.04 Desktop, while upgrading and installing Google Chrome:

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu18 --ansible-roles=bootstrap,grub-conf,hyper_kvm,google-chrome,scudcloud,sublime,ccollab-client --extra-vars="base_os_upgrade=yes"

Bootstrap Ubuntu 18.04 Desktop, while configuring Grub, upgrading it and installing Google Chrome:

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu18 --ansible-roles=bootstrap,grub-conf,google-chrome --extra-vars="base_os_upgrade=yes"

Bootstrap CentOS 6, while configuring Grub

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=centos6 --ansible-roles=bootstrap,grub-conf --extra-vars="base_os_upgrade=yes"

Bootstrap CentOS 7, while configuring Grub

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=centos7 --ansible-roles=bootstrap,grub-conf --extra-vars="base_os_upgrade=yes"

## Installing SVAuto dependencies

You'll need to install the dependencies to enable all SVAuto's functionalities.

To install everything, run on your Ubuntu 18.04 Server or Desktop, the following command:

Big URL

Server:

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu18 --ansible-roles=bootstrap,grub-conf,apache2,hyper_kvm,hyper_lxd,hyper_virtualbox,docker,vagrant,amazon_ec2_tools,redhat_tools_ubuntu,os_clients,packer,vsftpd,post-cleanup --ansible-extra-vars="ubuntu_install=server"

Desktop:

    curl -L https://raw.githubusercontent.com/tmartinx/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu18 --ansible-roles=bootstrap,grub-conf,apache2,hyper_kvm,hyper_lxd,hyper_virtualbox,docker,vagrant,amazon_ec2_tools,redhat_tools_ubuntu,os_clients,packer,vsftpd,post-cleanup --ansible-extra-vars="ubuntu_install=desktop"

Short URL

Server:

    bash <(curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/scripts/bootstrap-svauto-server.sh)

    curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/scripts/bootstrap-svauto-server.sh | bash

Desktop:

    bash <(curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/scripts/bootstrap-svauto-desktop.sh)

    curl -s https://raw.githubusercontent.com/tmartinx/svauto/dev/scripts/bootstrap-svauto-desktop.sh | bash

## Building images with SVAuto, function "Image Factory"

Resource to build a clean Ubuntu or CentOS images, without Ansible roles, just Packer and upstream ISO media.

    # Ubuntu Bionic 18.04 - Blank server
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu18 --product=ubuntu --version=18.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum

    # Ubuntu Xenial 16.04 - Blank server
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu16 --product=ubuntu --version=16.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum

    # Ubuntu Trusty 14.04 - Blank server
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu14 --product=ubuntu --version=14.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum

    # CentOS 6 - Blank server - Old Linux 2.6
    ./svauto.sh --image-factory --release=dev --base-os=centos6 --product=centos --version=6 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum

    # CentOS 7 - Blank server - Old Linux 3.10
    ./svauto.sh --image-factory --release=dev --base-os=centos7 --product=centos --version=7.1 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum

Resource to build a clean Ubuntu or CentOS images, with Packer and Ansible, plus upstream ISO media.

    # Ubuntu Bionic 18.04 - Blank server - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu18 --product=ubuntu --version=18.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum --ansible-roles=bootstrap,cloud-init,grub-conf,post-cleanup

    # Ubuntu Xenial 16.04 - Blank server - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu16 --product=ubuntu --version=16.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum --ansible-roles=bootstrap,cloud-init,grub-conf,post-cleanup

    # Ubuntu Trusty 14.04 - Blank server - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=ubuntu14 --product=ubuntu --version=14.04 --product-variant=r1 --qcow2 --vm-xml --sha256sum --ansible-roles=bootstrap,cloud-init,grub-conf,post-cleanup
 
    # CentOS 7 - Blank server - Old Linux 3.10 - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=centos7 --product=centos --version=7.1 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum --ansible-roles=bootstrap,grub-conf,cloud-init,post-cleanup

    # CentOS 7 - Blank server - Linux 3.18 from Xen 4.6 CentOS Repo - Much better KVM / Xen support - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=centos7 --product=centos --version=7.1 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum --ansible-roles=centos-xen,bootstrap,grub-conf,cloud-init,post-cleanup

    # CentOS 6 - Blank server - Old Linux 2.6 - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=centos6 --product=centos --version=6 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum --ansible-roles=bootstrap,cloud-init,grub-conf,post-cleanup

    # CentOS 6 - Blank server - Linux 3.18 from Xen 4.4 CentOS Repo - Much better KVM / Xen support - Bootstrapped
    ./svauto.sh --image-factory --release=dev --base-os=centos6 --product=centos --version=6 --product-variant=sv-1 --qcow2 --vm-xml --sha256sum --ansible-roles=centos-xen,bootstrap,grub-conf,cloud-init,grub-conf,post-cleanup
