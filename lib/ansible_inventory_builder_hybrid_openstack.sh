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

ansible_inventory_builder_hybrid_os()
{

	echo "$ANSIBLE_HOSTS_LIST" | grep "$OS_STACK_NAME" > "$STACK_LIST_FILE"

	while read line
	do

		INSTANCE_NAME=$(echo $line | cut -d \  -f 1)
		#INSTANCE_IPv4=$(echo $line | cut -d \  -f 2)

		INSTANCES_GROUPS_LIST=$(echo $INSTANCE_NAME | sed -e 's/'$OS_STACK_NAME'\-//g' | sed -e 's/\(.*\)-.*$/\1 /')
		INSTANCES_TMP="$INSTANCES_TMP $INSTANCES_GROUPS_LIST"

	done < $STACK_LIST_FILE

	for T in `echo $INSTANCES_TMP`
	do

		echo "$T" >> $TMP_FILE

	done

	INSTANCES_CONDENSED_LIST=$(cat $TMP_FILE | sort | uniq)

	echo

	for G in `echo $INSTANCES_CONDENSED_LIST`
	do

		GN=`echo $G | sed -e 's/\-/_/g'`

		echo "[$GN]"

		while read line
		do

			echo "$line" | grep "$G" | cut -d \  -f 2

		done < $STACK_LIST_FILE

		echo

	done

}
