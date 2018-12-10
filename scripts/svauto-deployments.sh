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


for i in "$@"
do
case $i in

        --base-os=*)

                BASE_OS="${i#*=}"
                shift
                ;;

	--ansible-remote-user=*)

		ANSIBLE_REMOTE_USER="${i#*=}"
		shift
		;;

	--ansible-inventory-builder=*)

		ANSIBLE_INVENTORY_ENTRY_1="${i#*=}"
		shift
		;;

	--ansible-playbook-builder=*)

		ANSIBLE_PLAYBOOK_ENTRY_1="${i#*=}"
		shift
		;;

	--ansible-extra-vars=*)

		ALL_ANSIBLE_EXTRA_VARS="${i#*=}"
		shift
		;;

esac
done


clear


echo
echo "Welcome to SVAuto, the Save Automation!"

echo
echo "Installing SVAuto basic dependencies (Git & Ansible):"


case $BASE_OS in

	ubuntu*)

		echo
		echo "Running: \"sudo apt install git python-minimal\""

		sudo apt -y install git python-minimal &>/dev/null

		;;

	centos*)

		echo
		echo "Running: \"sudo yum install git\""

		sudo yum -y install git &>/dev/null
		;;

	*)

	        echo
		echo "O.S. not detected, aborting!"

		exit 1

		;;

esac


if  [ ! -d ~/svauto ]
then
        echo
        echo "Downloading SVAuto into your home directory..."
        echo

        cd ~
        git clone -b dev https://github.com/tmartinx/svauto
else
        echo
        echo "Apparently, you already have SVAuto, enjoy it!"
        echo
fi


if  [ ! -f ~/svauto/svauto.sh ]
then
	echo
	echo "WARNING!"
	echo "SVAuto main script not found, Git clone might have failed."

	echo

	exit 1
fi


pushd ~/svauto &>/dev/null

./svauto.sh --ansible-remote-user="$ANSIBLE_REMOTE_USER" --ansible-inventory-builder="$ANSIBLE_INVENTORY_ENTRY_1" --ansible-playbook-builder="$ANSIBLE_PLAYBOOK_ENTRY_1" --ansible-extra-vars="$ALL_ANSIBLE_EXTRA_VARS"
