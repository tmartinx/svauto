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

# Ubuntu 18.04 Packer Build with Ansible
./svauto.sh --packer-builder --base-os=ubuntu18 --release=dev --product=ubuntu --version=18.04 --product-variant=sv-1 --qcow2 --ova --vm-xml --sha256sum \
	--ansible-playbook-builder="default,cloud-init,bootstrap;base_os_upgrade=true;mode=server;os_release=rocky;regular_system_user=tcmc,grub,post-cleanup-image" \
	--packer-max-tries=3 # --dry-run
