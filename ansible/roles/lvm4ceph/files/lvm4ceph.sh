#! /bin/bash

for i in "$@"
do
case $i in

        --host-vars)

                PRINT_HOST_VARS="yes"
                shift
                ;;

        --lvm-devices)

                LVM_DEVICES="yes"
                shift
                ;;

       --exclude-mdadm-devs=*)

                MDADM_LIST="${i#*=}"
                shift
                ;;

esac
done

# Identify the underlying devices of /dev/md0 and exclude them from being used
# for LVM PVs:

MDADM_DEVICES=`mdadm --query --detail /dev/md0 | grep dev\/sd | awk '{print $7}' | cut -d \/ -f 3 | sed 's/[0-9]*//g' | xargs`

TO_EXCLUDE=$(
for X in $MDADM_DEVICES;
do
        echo -n "$X|"
done
echo -n part
)

# Create a LVM VG for each remaining ATA disk:

LVM_PVS=$(ls -l /dev/disk/by-id/ata*  | grep -vEi $TO_EXCLUDE | awk '{print $9}' | cut -d \/ -f 5 | xargs)

if [ "$PRINT_HOST_VARS" == "yes" ]
then
        echo "lvm_volumes:"

        for Y in $LVM_PVS;
        do
                echo "  - data: $Y"
                echo "    data_vg: $Y"
        done

        exit 1
fi

if [ "$LVM_DEVICES" == "yes" ]
then
        for Y in $LVM_PVS;
        do
                pvcreate /dev/disk/by-id/$Y
                vgcreate $Y /dev/disk/by-id/$Y
                lvcreate -n $Y -l 100%FREE $Y
        done

        exit 1
fi
