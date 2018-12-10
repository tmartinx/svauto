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


export LC_ALL=C

for i in "$@"
do
case $i in

	--os-project=*)

		PROJECT="${i#*=}"
		shift
		;;

	--os-stack=*)

		STACK="${i#*=}"
		shift
		;;

esac
done


if [ ! -f /usr/local/etc/$PROJECT-openrc.sh ]
then
	echo
	echo "OpenStack Credentials for "$PROJECT" account not found, aborting!"
	exit 1
else
	echo
	echo "Loading OpenStack credentials for "$PROJECT" account..."
	source /usr/local/etc/$PROJECT-openrc.sh
fi


if heat stack-show $STACK 2>&1 > /dev/null
then
	echo
	echo "Stack found, proceeding..."
else
	echo
	echo "Stack not found! Aborting..."
	exit 1
fi


INSTANCE_ID=$(nova list | grep $STACK-nfv | awk $'{print $2}')


if [ -z $INSTANCE_ID ]
then
	echo
	echo "Warning! No compatible Instances was detected on your \"$STACK\" Stack!"
	echo "Possible causes are:"
	echo
	echo " * Missing Instance ID for one or more Custom's Instances."
	echo " * You're running a Stack that is not compatbile with the minimum requirements."
	echo
	exit 1
fi


BRIDGES=$(virsh dumpxml $INSTANCE_ID | grep source\ bridge | tail -n 2 | awk -F\' '{print $2}' | xargs)


for X in $BRIDGES; do

	sudo brctl setageing $X 0

	echo
	echo "Linux Bridge $X of L2 NFV Instance is now a dumb hub."

done
