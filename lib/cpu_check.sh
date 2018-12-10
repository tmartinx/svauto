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

cpu_check()
{

	CPU_CORES=$(grep -c ^processor /proc/cpuinfo)

	if [ $CPU_CORES -lt 4 ]
	then
		echo
		echo "WARNING!!!"
		echo
		echo "You do not have enough CPU Cores to run this system!"

		exit 1
	fi


	sudo apt-get -y install cpu-checker 2>&1 > /dev/null


	if ! /usr/sbin/kvm-ok 2>&1 > /dev/null
	then
		echo "WARNING!!!"
		echo
		echo "Virtualization NOT supported on this CPU or it is not enabled on your BIOS"

		exit 1
	fi

}
