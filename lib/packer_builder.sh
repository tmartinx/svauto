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

packer_builder()
{

	PACKER_FILES=build-$PRODUCT-$BUILD_RAND-packer-files
	PACKER_OUTPUT_DIR=build-$PRODUCT-$BUILD_RAND-output-dir


	case "$BASE_OS" in

	        ubuntu18)
			OS_LABEL="bionic"
			;;

	        ubuntu16)
			OS_LABEL="xenial"
			;;

		centos6)
			OS_LABEL="el6"
			;;

		centos7)
			OS_LABEL="el7"
			;;

	        *)
			echo
			echo "Usage: $0 --base-os={ubuntu18|ubuntu16|centos6|centos7}"

			exit 1
			;;

	esac


	echo
	echo "Starting SVAuto's Packer Builder!"


	if [ ! -z $PRODUCT_VARIANT ]; then
		PACKER_VM_NAME=$PRODUCT-$VERSION-$PRODUCT_VARIANT-$OS_LABEL-amd64
	else
		PACKER_VM_NAME=$PRODUCT-$VERSION-$OS_LABEL-amd64
	fi


	FIND_PREVIOUS_RAW_IMAGE=$(find packer -name "$PACKER_VM_NAME.raw")


	if file $FIND_PREVIOUS_RAW_IMAGE &>/dev/null
	then

		echo
		echo "Warning! SVAuto found a previous build of this very same image."
		echo "Not building it again... Aborting this build!"

		echo
		echo "Build found: $FIND_PREVIOUS_RAW_IMAGE"

		exit 0

	fi


	echo
	echo "Preparing Packer build temp dir (packer/"$PACKER_FILES")..."

	# Creating temp dirs to host Packer yaml file, Ansible playbook and xml files
	mkdir packer/$PACKER_FILES


	# Defining the auto-generated Packer file to build the image
	PACKER_FILE="packer/$PACKER_FILES/$PACKER_VM_NAME-packer.yaml"


	# Coping the template to Packer files subdir
	case "$BASE_OS" in

	        ubuntu18)
			cp packer/ubuntu18-template.yaml $PACKER_FILE
			;;

		ubuntu16)
	                cp packer/ubuntu16-template.yaml $PACKER_FILE
			;;

		centos6)
			cp packer/centos6-template.yaml $PACKER_FILE
			;;

		centos7)
			cp packer/centos7-template.yaml $PACKER_FILE
			;;

	        *)
			echo
			echo "Usage: $0 --base-os={ubuntu18|ubuntu16|centos6|centos7}"

			exit 1
			;;

	esac


	# Defining the dynamic Ansible Inventory and Playbook files location.
	# It overrides the default values configured on svauto.sh.

	ANSIBLE_PLAYBOOK_FILE="$PACKER_VM_NAME-ansible-playbook.yaml"


	echo "$ANSIBLE_PLAYBOOK_FILE_IN_MEM" > packer/$PACKER_FILES/$ANSIBLE_PLAYBOOK_FILE


	# Updating Packer VM build template yaml file
	sed -i -e 's/"output_directory": "",/"output_directory": "\.\.\/packer\/'$PACKER_OUTPUT_DIR'",/g' $PACKER_FILE
	sed -i -e 's/"vm_name": "",/"vm_name": "'$PACKER_VM_NAME.raw'",/g' $PACKER_FILE
	sed -i -e 's/"playbook_file": ""/"playbook_file": "\.\.\/packer\/'$PACKER_FILES'\/'$ANSIBLE_PLAYBOOK_FILE'"/g' $PACKER_FILE


	# SVXYZ needs a bigger image, lets do this only for it
	if [ "$PRODUCT" == "svxyz" ]; then sed -i -e 's/"disk_size":.*/"disk_size": "15360",/g' $PACKER_FILE ; fi


	if [ "$OVF" == "yes" ]
	then

		echo
		echo "Creating "$PACKER_VM_NAME" VM OVF file..."

		if [ "$PRODUCT" == "svnfv" ] || [ "$PRODUCT" == "cs-svnfv" ] ; then
			cp misc/vmware/ovf-template-4nic.ovf packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
		else
			cp misc/vmware/ovf-template-2nic.ovf packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
		fi

		sed -i -e 's/{{vm_name}}/'"$PACKER_VM_NAME"'/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf

		case "$BASE_OS" in

		        ubuntu*)
				sed -i -e 's/{{ovf_id}}/94/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
				sed -i -e 's/{{vmw_ostype}}/ubuntu64Guest/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
				;;

			centos*)
				sed -i -e 's/{{ovf_id}}/107/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
				sed -i -e 's/{{vmw_ostype}}/centos64Guest/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf
				;;

		        *)
				echo
				echo "Usage: $0 --base-os={ubuntu18|ubuntu16|centos6|centos7}"

				exit 1
				;;

		esac

	fi


	if [ "$VM_XML" == "yes" ]
	then

		echo
		echo "Creating "$PACKER_VM_NAME" VM XML file..."

		case "$BASE_OS" in

		        ubuntu*)
				if [ "$PRODUCT" == "svnfv" ] || [ "$PRODUCT" == "cs-svnfv" ] ; then
					cp misc/libvirt/libvirt-ubuntu-4nic.xml packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				else
					cp misc/libvirt/libvirt-ubuntu-2nic.xml packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				fi
				sed -i -e 's/{{vm_name}}/'"$PACKER_VM_NAME"'/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				;;

			centos*)
				if [ "$PRODUCT" == "svnfv" ] || [ "$PRODUCT" == "cs-svnfv" ] ; then
					cp misc/libvirt/libvirt-centos-4nic.xml packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				else
					cp misc/libvirt/libvirt-centos-2nic.xml packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				fi
				sed -i -e 's/{{vm_name}}/'"$PACKER_VM_NAME"'/g' packer/$PACKER_FILES/"$PACKER_VM_NAME".xml
				;;

		        *)
				echo
				echo "Usage: $0 --base-os={ubuntu18|ubuntu16|centos6|centos7}"
				exit 1
				;;

		esac

	fi


	if [ "$DRY_RUN" == "yes" ]
	then

		echo
		echo "Dry run called, not running Packer, to run it manually, you can type:"

		echo
		echo "pushd ansible ; packer build ../packer/$PACKER_FILES/$PACKER_VM_NAME-packer.yaml ; popd"

	else

		pushd ansible

		if [ ! -z $MAX_TRIES ] && [ $MAX_TRIES -gt 1 ]
		then

			TRIES=1

			while [ $TRIES -le $MAX_TRIES ]
			do

				echo
				echo "Packer is now building: "$PACKER_VM_NAME" with Ansible (try: $TRIES of $MAX_TRIES)..."
				echo


				if [ $TRIES -ge 2 ] && [ -d "$packer/$PACKER_OUTPUT_DIR" ]
				then

					if [ -d packer/$PACKER_OUTPUT_DIR ]; then

						echo
						echo "Removing remainings of previous failed build..."

						rm -rf packer/$PACKER_OUTPUT_DIR

					fi

				fi


				if packer build ../packer/$PACKER_FILES/$PACKER_VM_NAME-packer.yaml
				then

					echo
					echo "Packer build okay, proceeding..."

					break

				else

					echo
					echo "Packer build \"$TRIES\" failed!"

					((TRIES++))

					echo
					echo "Trying it again (\"$TRIES\" of \"$MAX_TRIES\")..."

				fi

			done

			if [ $TRIES -eq $MAX_TRIES ]
			then

				echo
				echo "WARNING!!!"
				echo
				echo "$MAX_TRIES attempts of Packer builds failed! ABORTING!!!"

				exit 1

			fi

		else

			echo
			echo "Packer is now building: "$PACKER_VM_NAME" with Ansible..."
			echo

			if packer build packer/$PACKER_FILES/$PACKER_VM_NAME-packer.yaml
			then
			        echo
			        echo "Packer build okay, proceeding..."
			else
				echo
			        echo "WARNING!!!"
				echo
			        echo "Packer build failed! ABORTING!!!"

			        exit 1
			fi

		fi

		popd

	fi


	if [ ! "$DRY_RUN" == "yes" ]
	then

		[ "$OVF" == "yes" ] && mv packer/$PACKER_FILES/"$PACKER_VM_NAME".ovf packer/$PACKER_OUTPUT_DIR

		[ "$VM_XML" == "yes" ] && mv packer/$PACKER_FILES/"$PACKER_VM_NAME".xml packer/$PACKER_OUTPUT_DIR

		if [ "$QCOW2" == "yes" ]; then
			echo
			echo "Converting "$PACKER_VM_NAME" RAW image to Compressed QCoW2..."
			qemu-img convert -p -f raw -O qcow2 -c packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.qcow2c
		fi


		if [ "$OVA" == "yes" ]; then

			echo
			echo "Creating "$PACKER_VM_NAME".ova file"

			vboxmanage convertfromraw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.vmdk --format vmdk --variant Stream

			echo
			pushd packer/$PACKER_OUTPUT_DIR

			dd if="$PACKER_VM_NAME"-disk1.vmdk of="$PACKER_VM_NAME"-disk1.descriptor bs=1 skip=512 count=1024 &>/dev/null

			sed -i -e 's/ide/lsilogic/g' "$PACKER_VM_NAME"-disk1.descriptor

			dd conv=notrunc,nocreat if="$PACKER_VM_NAME"-disk1.descriptor of="$PACKER_VM_NAME"-disk1.vmdk bs=1 seek=512 count=1024 &>/dev/null

			OVF_SIZE=`wc -c "$PACKER_VM_NAME"-disk1.vmdk | cut -d \  -f 1`
			OVF_POPULATEDSIZE=$(( $OVF_SIZE * 3))

			sed -i -e 's/{{ovf_size}}/'"$OVF_SIZE"'/g' "$PACKER_VM_NAME".ovf
			sed -i -e 's/{{ovf_populatedSize}}/'"$OVF_POPULATEDSIZE"'/g' "$PACKER_VM_NAME".ovf

			VMDK_SHA1=`sha1sum "$PACKER_VM_NAME"-disk1.vmdk | xargs | cut -d \  -f 1`
			OVF_SHA1=`sha1sum "$PACKER_VM_NAME".ovf | xargs | cut -d \  -f 1`

			echo "SHA1("$PACKER_VM_NAME"-disk1.vmdk)= "$VMDK_SHA1"" > "$PACKER_VM_NAME".mf
			echo "SHA1("$PACKER_VM_NAME".ovf)= "$OVF_SHA1"" >> "$PACKER_VM_NAME".mf

			tar -cf "$PACKER_VM_NAME".ova "$PACKER_VM_NAME".ovf "$PACKER_VM_NAME".mf "$PACKER_VM_NAME"-disk1.vmdk

			rm -f "$PACKER_VM_NAME"-disk1.vmdk

			echo
			popd

		fi


		if [ "$VMDK" == "yes" ]; then
			echo
			echo "Converting "$PACKER_VM_NAME" RAW image to VMDK format..."
			qemu-img convert -p -f raw -O vmdk -o adapter_type=lsilogic packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.vmdk
		fi


		if [ "$VHD" == "yes" ]; then
			echo
			echo "Converting "$PACKER_VM_NAME" RAW image to VHD format..."
			qemu-img convert -p -f raw -O vpc -o subformat=dynamic packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.vhd
		fi


		if [ "$VHDX" == "yes" ]; then
			echo
			echo "Converting "$PACKER_VM_NAME" RAW image to VHDX format..."
			qemu-img convert -p -f raw -O vhdx -o subformat=dynamic packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.vhdx
		fi


		if [ "$VDI" == "yes" ]; then
			echo
			echo "Converting "$PACKER_VM_NAME" RAW image to VDI format..."
			qemu-img convert -p -f raw -O vdi packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME".raw packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.vdi
		fi


		if [ "$SHA256SUM" == "yes" ]; then

			echo
			echo "Creating SHA256SUMs of files located here: \"packer/$PACKER_OUTPUT_DIR/\"..."

			if [ -d packer/"$PACKER_OUTPUT_DIR"/ ]
			then

				echo
				pushd packer/"$PACKER_OUTPUT_DIR"

				LIST=`ls -1 | grep -v \.raw | grep -v \.ovf | grep -v \.mf | grep -v \.descriptor | grep -v \.xml | xargs`

				echo

				for X in $LIST
				do
					echo "File: \"$X.sha256\"..."
					sha256sum "$X" >> "$X".sha256
				done

				echo
				popd

			else

				echo
				echo "Warning! Can not find the packer/\"$PACKER_OUTPUT_DIR\" subdir."

			fi

		fi


		if [ "$PACKER_TO_OS" == "yes" ]
		then

			if [ "$QCOW2" != "yes" ]; then

				echo
				echo "Aborting! Uploading images stright into OpenStack Glance, requires qcow2 images."

				exit 1

			fi

			if [ ! -f ~/$OS_PROJECT-openrc.sh ]
			then
				echo
				echo "OpenStack Credentials for "$OS_PROJECT" account not found, aborting!"

				exit 1
			else
				echo
				echo "Loading OpenStack credentials for "$OS_PROJECT" account..."
				source ~/$OS_PROJECT-openrc.sh

				echo
				echo "Importing QCoW2 Image into Glance (only works if the QCoW2 is being created)..."

				openstack image create --file packer/$PACKER_OUTPUT_DIR/"$PACKER_VM_NAME"-disk1.qcow2c --disk-format qcow2 --container-format bare --public "$PACKER_VM_NAME"
			fi

		fi

	fi

}
