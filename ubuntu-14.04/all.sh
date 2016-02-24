#!/bin/bash
##
##  Made by Joarc
##  Use on own risk
##

## Start message
echo "¤--------------------¤"
echo "|                    |"
echo "|   General Report   |"
echo "|                    |"
echo "¤--------------------¤"
date
echo "----------------------"
echo ""; echo ""

## Get all packages that need upgrading
echo "-[ Packages ]-"
echo "These packages need to be updated:"
echo ""
apt-get -qq -s upgrade > apt-upgrade.log
while read p; do
  if [[ $p == Inst* ]]
  then
    echo $p |cut -d ' ' -f2,3
  fi
done <apt-upgrade.log
echo ""; echo ""

## Get server load
echo "-[ Server Load ]-"
echo ""
cpus=$(nproc)
loadavg=$(cat /proc/loadavg |cut -d ' ' -f1,2,3)
loadf=$(echo $loadavg | cut -d ' ' -f1)
loads=$(echo $loadavg | cut -d ' ' -f2)
loadt=$(echo $loadavg | cut -d ' ' -f3)
if (( $(echo "$loadf >= $cpus" | bc -l) )); then
  echo "In the previous minute, load has been over the amount of cpus that this server has!"
elif (( $(echo "$loads >= $cpus" | bc -l) )); then
  echo "In the previous 5 minutes, load has been over the amount of cpus that this server has!"
elif (( $(echo "$loadt >= $cpus" | bc -l) )); then
  echo "In the previous 15 minutes, load has been over the amount of cpus that this server has!"
else
  echo "Load has been under the amount of cpus that this server has."
fi
echo "Load 1m: $loadf, Load 5m: $loads, Load 15m: $loadt"
echo "CPU Amount: $cpus"
echo ""; echo ""

## Harddrive
echo "-[ Harddrive ]-"
echo ""
df -h > harddrives.log
while read p; do
  file=$(echo $p |cut -d' ' -f1)
  size=$(echo $p |cut -d' ' -f2)
  used=$(echo $p |cut -d' ' -f3)
  avai=$(echo $p |cut -d' ' -f4)
  usag=$(echo $p |cut -d' ' -f5)
  moun=$(echo $p |cut -d' ' -f6)
  if [[ $moun != /run* ]] && [[ $moun != /sys* ]] && [[ $moun != /dev* ]]; then
    echo "$moun	| $used/$size ($avai, $usag) | $file"
  fi
done <harddrives.log
echo ""; echo ""


## Network
echo "-[ Networking ]-"
echo ""
echo "ping -c10 8.8.8.8"
ping -c10 8.8.8.8
echo ""
echo "Interfaces and their ips:"
/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }'
