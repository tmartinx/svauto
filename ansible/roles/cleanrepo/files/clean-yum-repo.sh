#! /bin/bash

for X in /etc/yum.repos.d/Custom*; do sed -i -e 's/ftp:.*@ftp/ftp:\/\/{{ftp_username}}:{{ftp_password}}@ftp/g' $X ; sed -i -e 's/^/#/g' $X ; done
