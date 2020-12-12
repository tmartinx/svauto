#! /bin/bash

# Copyright 2020, TCMC.
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


if [ -f /etc/os-release ]; then

    # freedesktop.org and systemd
    . /etc/os-release
    OS_NAME=$NAME
    VERSION_NUMBER=$VERSION_ID

elif type lsb_release >/dev/null 2>&1; then

    # linuxbase.org
    OS_NAME=$(lsb_release -si)
    VERSION_NUMBER=$(lsb_release -sr)

elif [ -f /etc/lsb-release ]; then

    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    VERSION_NUMBER=$DISTRIB_RELEASE

elif [ -f /etc/debian_version ]; then

    # Older Debian/Ubuntu/etc.
    OS_NAME=Debian
    VERSION_NUMBER=$(cat /etc/debian_version)

else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS_NAME=$(uname -s)
    VERSION_NUMBER=$(uname -r)
fi

OS_NAME=`echo $OS_NAME | tr A-Z a-z`
export $OS_NAME

#export $"VERSION_NUMBER"
