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
echo ""
## Harddrive
harddrives=$(df -h)
echo 
echo ""; echo ""
