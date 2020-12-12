#! /bin/bash

# Copyright 2020, TCMC.
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

ansible_runner()
{

	if ! which ansible-playbook >/dev/null
	then

		source lib/os-detection.sh

		case $OS_NAME in

			ubuntu*)

				echo
				echo "Running: \"sudo apt install ansible\""

				# All new on Ubuntu 18.04
				sudo apt update &>/dev/null
				sudo apt -y install ansible &>/dev/null

				;;

			centos*)

				echo
				echo "Running: \"sudo yum install ansible\""

				sudo yum -y install epel-release &>/dev/null
				sudo yum -y install ansible libselinux-python &>/dev/null
				;;

			*)

		        echo
			echo "O.S. not detected, cound not install Ansible for you!"

			exit 1

			;;

		esac

	fi

        echo
        echo "SVAuto is running Ansible:"

        echo
	echo "pushd ansible"

	echo
	pushd ansible

	echo
	echo "Creating both Ansible's Inventory and the Playbook..."

	if [ "$ANSIBLE_DUMP" == "yes" ];
	then

		echo
		echo "Dumping Inventory \"$ANSIBLE_INVENTORY_FILE\" file:"

		cat "$ANSIBLE_INVENTORY_FILE"

	fi

	if [ "$ANSIBLE_DUMP" == "yes" ]
	then

		echo
		echo "Dumping Top-Level Playbook \"$ANSIBLE_PLAYBOOK_FILE\' file:"

		cat "$ANSIBLE_PLAYBOOK_FILE"

	fi

	# TODO: Review the need for this block:
	if [ -z "$OS_PROJECT" ] || [ -z "$RUNTIME_MODE" ]
	then

		echo
		echo "Warning! Not running against OpenStack, auto-building Ansible's files from memory..."

		echo "$ANSIBLE_INVENTORY_FILE_IN_MEM" >> $ANSIBLE_INVENTORY_FILE

		echo "$ANSIBLE_PLAYBOOK_FILE_IN_MEM" >> $ANSIBLE_PLAYBOOK_FILE

		#echo "$ANSIBLE_EXTRA_VARS_FILE_IN_MEM" > $ANSIBLE_EXTRA_VARS_FILE

	fi

	if [ "$DRY_RUN" == "yes" ]
	then

		echo
		echo "Not running Ansible on dry run..."

	        echo
	        echo "NOTE: You can manually run Ansible by typing:"
	        echo
	        echo "pushd ansible"
	        echo "ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE"
	        echo

	else

		echo
		echo "ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE"

		if ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE # -e \""$ANSIBLE_EXTRA_VARS $EXTRA_VARS"\"
		then

			echo
			echo "Ansilble applied the playbook correctly... Success!"
			echo

			if [ ! -z $OS_STACK_NAME ] || [ "$LABIFY" == "yes" ]
			then

				echo "Your brand new Custom's Stack is reachable through SSH:"

				INSTANCES_CONDENSED_LIST=$(cat $TMP_FILE | sort | uniq)

				echo

				for G in `echo $INSTANCES_CONDENSED_LIST`
				do

					while read line
					do

						G_IP=$(echo "$line" | grep "$G" | cut -d \  -f 2)

						if [ ! -z "$G_IP" ]; then echo "ssh $ANSIBLE_REMOTE_USER@$G_IP # $G" ; fi

					done < $STACK_LIST_FILE

					echo

				done

			fi

		else

			echo
			echo "Ansible Playbook failed to apply! ABORTING!!!"
			echo

			exit 1

		fi

	fi

	popd
	echo

}
