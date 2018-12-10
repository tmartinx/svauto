#! /bin/bash

# Copyright 2018, TCMC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

move2webroot()
{

        echo
        echo "Moving all images created during this build, to the Web Root."


        find packer/build* -name "*.raw" -exec rm -f {} \;

	find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_STOCK \;


        if [ "$HEAT_TEMPLATES" == "custom-dev" ]
        then

                echo
                echo "Copying Custom's Heat Templates into web public subdirectory..."

                cp tmp/sv/custom-stack-*.yaml $WEB_ROOT_STOCK/

        fi

}
