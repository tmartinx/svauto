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

hostname_check()
{

	# Detect some of the local settings:
	WHOAMI=$(whoami)
	UBUNTU_HOSTNAME=$(hostname)
	FQDN=$(hostname -f)
	DOMAIN=$(hostname -d)


	# If the hostname and hosts file aren't configured according, abort.
	if [ -z $UBUNTU_HOSTNAME ]; then
		echo "Hostname not found... Configure the file /etc/hostname with your hostname. ABORTING!"

		exit 1
	fi

	if [ -z $DOMAIN ]; then
		echo "Domain not found... Configure the file /etc/hosts with your \"IP + FQDN + HOSTNAME\". ABORTING!"

		exit 1
	fi

	if [ -z $FQDN ]; then
		echo "FQDN not found... Configure your /etc/hosts according. ABORTING!"

		exit 1
	fi


	# Display local configuration
	echo
	echo "Auto-detected local configuration:"
	echo
	echo -e "* Username:"'\t'$WHOAMI
	echo -e "* Hostname:"'\t'$UBUNTU_HOSTNAME
	echo -e "* FQDN:"'\t''\t'$FQDN
	echo -e "* Domain:"'\t'$DOMAIN

}
