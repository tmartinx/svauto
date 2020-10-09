#! /bin/bash 

INSTANCES="vosctrl-1 vosctrl-2 vosctrl-3"

for X in $INSTANCES
do
	virsh snapshot-create-as --domain $X --name snap-1
done
