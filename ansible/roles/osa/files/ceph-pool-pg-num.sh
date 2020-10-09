#! /bin/bash

for P in `ceph osd pool ls`
do
        ceph osd pool set $P pg_num 32
        ceph osd pool set $P pgp_num 32
done
