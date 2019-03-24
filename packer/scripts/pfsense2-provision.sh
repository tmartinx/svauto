#!/bin/sh

# replace <if></if> section of config.xml with proper names for running on KVM VirtIO Net
echo "PROVISIONING: Changing /conf/config.xml and /conf.default/config.xml:"
sed -i -E 's$<if>em0</if>$<if>vtnet0</if>$g' /conf/config.xml
sed -i -E 's$<if>em1</if>$<if>vtnet1</if>$g' /conf/config.xml
sed -i -E 's$<if>em0</if>$<if>vtnet0</if>$g' /conf.default/config.xml
sed -i -E 's$<if>em1</if>$<if>vtnet1</if>$g' /conf.default/config.xml

# print grep results for verification during packer build:
echo "PROVISIONING: grep -H <if> ... output:"
grep -H '<if>' /conf/config.xml
grep -H '<if>' /conf.default/config.xml
