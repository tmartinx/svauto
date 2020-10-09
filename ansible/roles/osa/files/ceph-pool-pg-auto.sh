#! /bin/bash

ceph mgr module enable pg_autoscaler

for P in `ceph osd pool ls`
do
        ceph osd pool set $P pg_autoscale_mode on
done
