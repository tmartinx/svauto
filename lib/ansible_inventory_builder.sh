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


# Outputs an Ansible Inventory file
ansible_inventory_builder()
{

	ENTRY_COUNTER=1


	while [ $ENTRY_COUNTER -le $ANSIBLE_INVENTORY_TOTAL ]
	do

		ITEM=1

		for i in $(eval echo "\$ANSIBLE_HOST_ENTRY_${ENTRY_COUNTER}" | sed "s/,/ /g")
		do

			if [ $ITEM == 1 ]; then

				echo
				echo "[$i]"

				WHO_IS_ITEM_1="$i"

			fi

			if [ "$WHO_IS_ITEM_1" == "all:vars" ]
			then
				if [ ! $ITEM -le 1 ]; then echo "$i " ; fi
			else
				if [ ! $ITEM -le 1 ]; then echo -n "$i " ; fi
			fi

			(( ITEM++ ))

		done

		echo

		(( ENTRY_COUNTER++ ))

	done

}
