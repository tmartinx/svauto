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

# Second version of vagrant-builder.sh, still very basic but, supports dynamic
# playbook.

# Golang and NodeJS on CentOS 6 and 7:
#
# ./svauto.sh --vagrant=up --base-os=centos6 --product=svcs-build
# ./svauto.sh --vagrant=up --base-os=centos7 --product=svcs-build

# Build Custom Boxes
#
# ./svauto.sh --vagrant=up --base-os=centos7
# ./svauto.sh --vagrant=up --base-os=centos7
# ./svauto.sh --vagrant=up --base-os=centos6

vagrant_builder()
{

	#VAGRANT_DEFAULT_PROVIDER=libvirt

	RAND_PORT=`awk -v min=1025 -v max=9999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

	ANSIBLE_PLAYBOOK_FILE="vagrant-run-$BUILD_RAND.yml"


	case "$BASE_OS" in

		ubuntu14)
			VBOX="ubuntu/trusty64"
			;;

		ubuntu16)
			VBOX="ubuntu/xenial64"
			;;

		centos6)
			VBOX="centos/6"
			;;

		centos7)
			VBOX="centos/7"
			;;

		*)

			echo
			echo "Usage: $0 --base-os={ubuntu14|ubuntu16|centos6|centos7}"

	                exit 1
	                ;;

	esac


	case "$PRODUCT" in

		svnfv)

			VM_NAME="svnfv_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svnfv_1,bootstrap,svnfv >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		svdba)

			VM_NAME="svdba_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svdba_1,bootstrap,svdba >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		sveng)

			VM_NAME="sveng_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=sveng_1,bootstrap,sveng >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		*)

			echo
			echo "You must select a product to boot it up..."

			exit 1
			;;

	esac


	echo
	echo "Entering into: \"vagrant/$VM_NAME\" subdir and runnig \"vagrant $VAGRANT_MODE\" for you!"

	case "$VAGRANT_MODE" in

		up)

			mkdir -p vagrant/$VM_NAME

			cp vagrant/Vagrantfile_template vagrant/$VM_NAME/Vagrantfile


			sed -i -e 's/vagrant_run:.*/vagrant_run: "yes"/' ansible/group_vars/all

			sed -i -e 's/svauto_yum_host:.*/svauto_yum_host: \"'$SVAUTO_YUM_HOST'\"/' ansible/group_vars/all
			sed -i -e 's/custom_yum_host:.*/custom_yum_host: \"'$SV_YUM_HOST'\"/' ansible/group_vars/all


			VBOX_SANITIZED=$(echo $VBOX | sed -e 's/\//\\\//g')


			sed -i -e 's/{{vm_box}}/'$VBOX_SANITIZED'/g' vagrant/$VM_NAME/Vagrantfile
			sed -i -e 's/{{vm_name}}/'$VM_NAME'/g' vagrant/$VM_NAME/Vagrantfile
			sed -i -e 's/{{ssh_local_port}}/'$RAND_PORT'/g' vagrant/$VM_NAME/Vagrantfile


			sed -i -e 's/{{ansible_playbook_file}}/'$ANSIBLE_PLAYBOOK_FILE'/g' vagrant/$VM_NAME/Vagrantfile


			if [ "$DRY_RUN" == "yes" ]
			then

				echo
				echo "Not running \"vagrant up\"!"
				echo "Just creating the Vagrantfile for you, under vagrant/\"vagrant/$VM_NAME\" subdir..."
				echo

			else

				pushd vagrant/$VM_NAME

				echo
				vagrant up --provider=libvirt

				popd

			fi

			;;

		ssh)

			pushd vagrant/$VM_NAME
			vagrant ssh
			popd
			;;

		destroy)

			pushd vagrant/$VM_NAME
			vagrant destroy
			popd
			;;

		provision)

			pushd vagrant/$VM_NAME
			vagrant provision
			popd
			;;

	esac

}
