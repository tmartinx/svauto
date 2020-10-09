#! /bin/bash

for P in `ceph osd pool ls`
do
       ceph osd pool set $P size 2
done
