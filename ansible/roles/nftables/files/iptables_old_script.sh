#! /bin/bash

#
# Example Details:
#
# ens3 = WAN
# ens4 = LAN
# ens5 = MGMT

IPTABLES_BINARY=iptables-translate

# First, delete all:
$IPTABLES_BINARY -F
$IPTABLES_BINARY -X

echo

#
# COMMON Rules - Start
#

# Allow anything on the local link
$IPTABLES_BINARY -A INPUT  -i lo -j ACCEPT
$IPTABLES_BINARY -A OUTPUT -o lo -j ACCEPT

echo

#
# INPUT Rules
#

# Allow established, related packets back in
$IPTABLES_BINARY -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#$IPTABLES_BINARY -A INPUT -m conntrack --ctstate INVALID -j DROP

$IPTABLES_BINARY -A INPUT -m conntrack --ctstate NEW -p tcp --dport 53 -j ACCEPT
$IPTABLES_BINARY -A INPUT -m conntrack --ctstate NEW -p udp --dport 53 -j ACCEPT

$IPTABLES_BINARY -A INPUT -i ens3 -m conntrack --ctstate NEW -m tcp -p tcp --dport 22 -j ACCEPT

$IPTABLES_BINARY -A INPUT -i ens3 -j DROP

$IPTABLES_BINARY -A INPUT -i ens4 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES_BINARY -A INPUT -i ens5 -m conntrack --ctstate NEW -j ACCEPT

$IPTABLES_BINARY -A INPUT -j LOG
$IPTABLES_BINARY -A INPUT -j DROP

echo

#
# OUTPUT Rules
#

$IPTABLES_BINARY -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

$IPTABLES_BINARY -A OUTPUT -o ens3 -j ACCEPT
$IPTABLES_BINARY -A OUTPUT -o ens4 -j ACCEPT
$IPTABLES_BINARY -A OUTPUT -o ens5 -j ACCEPT


$IPTABLES_BINARY -A OUTPUT -j LOG
$IPTABLES_BINARY -A OUTPUT -j DROP

echo

#
# FORWARD Rules
#

# Allow established, related packets back in
$IPTABLES_BINARY -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#$IPTABLES_BINARY -A FORWARD -m conntrack --ctstate INVALID -j DROP

# WebServer Example
$IPTABLES_BINARY -A FORWARD -i ens3 -m conntrack --ctstate NEW -p tcp -d 172.16.1.10 --dport 8080 -j ACCEPT

$IPTABLES_BINARY -A FORWARD -i ens3 -j LOG
$IPTABLES_BINARY -A FORWARD -i ens3 -j DROP

#$IPTABLES_BINARY -A FORWARD -s 10.0.0.0/8 -i ens4 -o ens3 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES_BINARY -A FORWARD -i ens4 -o ens3 -j ACCEPT

$IPTABLES_BINARY -A FORWARD -i ens4 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES_BINARY -A FORWARD -i ens5 -m conntrack --ctstate NEW -j ACCEPT

$IPTABLES_BINARY -A FORWARD -j LOG
$IPTABLES_BINARY -A FORWARD -j DROP

echo

#
# NAT
#

# PREROUTING (Port Forward)
# WebServer Example
$IPTABLES_BINARY -A PREROUTING -t nat -i ens3 -p tcp --dport 80 -j DNAT --to 172.16.1.10:8080

# POSTROUTING
$IPTABLES_BINARY -t nat -A POSTROUTING -o ens3 -j MASQUERADE

echo

#
# COMMON Rules - End
#

$IPTABLES_BINARY -P INPUT DROP
$IPTABLES_BINARY -P FORWARD DROP
$IPTABLES_BINARY -P OUTPUT ACCEPT
