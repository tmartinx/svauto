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

update_web_dir_sha256sums()
{

	echo
	echo "Merging SHA256SUMS files together..."

	cat $WEB_ROOT_CS/*.sha256 2>/dev/null		>> $WEB_ROOT_CS/SHA256SUMS		; rm -f $WEB_ROOT_CS/*.sha256
	cat $WEB_ROOT_CS_LAB/*.sha256 2>/dev/null	>> $WEB_ROOT_CS_LAB/SHA256SUMS		; rm -f $WEB_ROOT_CS_LAB/*.sha256
	cat $WEB_ROOT_CS_RELEASE/*.sha256 2>/dev/null	>> $WEB_ROOT_CS_RELEASE/SHA256SUMS	; rm -f $WEB_ROOT_CS_RELEASE/*sha256
	cat $WEB_ROOT_STOCK/*.sha256 2>/dev/null	>> $WEB_ROOT_STOCK/SHA256SUMS		; rm -f $WEB_ROOT_STOCK/*.sha256
	cat $WEB_ROOT_STOCK_LAB/*.sha256 2>/dev/null	>> $WEB_ROOT_STOCK_LAB/SHA256SUMS	; rm -f $WEB_ROOT_STOCK_LAB/*.sha256

}
