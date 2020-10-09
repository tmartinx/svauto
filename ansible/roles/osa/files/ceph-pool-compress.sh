#! /bin/bash

for P in `ceph osd pool ls`
do
	ceph osd pool set $P compression_algorithm zlib # snappy
	ceph osd pool set $P compression_mode aggressive
	#ceph osd pool set $P compression_required_ratio <ratio>
	#ceph osd pool set $P compression_min_blob_size <size>
	#ceph osd pool set $P compression_max_blob_size <size>
done
