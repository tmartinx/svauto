#! /bin/bash

./svauto.sh \
	--environment-name="aio-1" \
	--ansible-inventory-subdir="$USER/inventory" \
	--ansible-inventory-preset="udns"
	--ansible-playbooks="top-level.yml,ubuntu-virt.yml"
