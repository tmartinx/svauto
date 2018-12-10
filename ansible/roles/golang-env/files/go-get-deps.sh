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

# InfluxDB
mkdir -p $GOPATH/src/github.com/influxdb
cd $GOPATH/src/github.com/influxdb
git clone --branch v0.8.8 https://github.com/influxdb/influxdb.git

# Go-Diameter
mkdir -p $GOPATH/src/github.com/fiorix
cd $GOPATH/src/github.com/fiorix
git clone https://github.com/fiorix/go-diameter.git
cd go-diameter
git checkout b4c1bac20b8e8e1ac7e17fb54dc83b155aacba21

# Calmh
mkdir -p $GOPATH/src/github.com/calmh
cd $GOPATH/src/github.com/calmh
git clone https://github.com/calmh/ipfix.git
cd ipfix
git checkout 6e3a744c25ea14b3ef5c74f9d5cb86e3ca90b658

# jwt-go
mkdir -p $GOPATH/src/github.com/dgrijalva
cd $GOPATH/src/github.com/dgrijalva
git clone https://github.com/dgrijalva/jwt-go.git
cd jwt-go
git checkout tags/v2.7.0

# Create Cloud Services sub-dir
mkdir -p $GOPATH/src/git.svc.rocks/octo

echo
