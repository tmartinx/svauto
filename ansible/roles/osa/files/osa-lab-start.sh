#! /bin/bash 

INSTANCES="vosctrl-1 vosctrl-2 vosctrl-3"

for X in $INSTANCES
do
	virsh start $X
done
