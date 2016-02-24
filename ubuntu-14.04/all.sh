#!/bin/bash
##
##  Made by Joarc
##  Use on own risk
##

## Get all packages that need upgrading
echo "These packages need to be updated:"
echo ""
apt-get -qq -s upgrade > apt-upgrade.log
while read p; do
  if [[ $p == Inst* ]]
  then
    echo $p |cut -d ' ' -f2,3
  fi
done <apt-upgrade.log
