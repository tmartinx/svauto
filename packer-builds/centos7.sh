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

# Linux SVNFV on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=centos --version=7 --product-variant=sv-1 --qcow2 --ova --vm-xml --sha256sum \
	--ansible-playbook-builder="default,cloud-init,bootstrap;base_os_upgrade=true;is_container=no,grub,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 # --dry-run
