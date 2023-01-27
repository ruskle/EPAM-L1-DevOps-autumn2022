#!/bin/bash

# scanning subnet
function scansubnet () {
  I=$( yum list installed | grep nmap) 
  if [[ -z "$I" ]]
  then
    echo "111111" | sudo -S yum install nmap -y
    echo "test"
  else
    echo "nmap installed"
    
  fi
  NETIPANDMASK=$( ip route | grep "src $MAINIP" | awk '{print $1}' )
  nmap -sn $NETIPANDMASK |  grep "Nmap scan" | awk '{print $5, $6}'
}

# scan ports for ip
function scanip () {
  # check for valid ip
  echo "$command" | grep -Eq "$ip_regex"
  if [[ $? == 0 ]]
  then 
    nmap -p0-1023 $command
  else
    echo "invalid IP"
  fi
}

command=$1
# regex for checking valid ip
ip_regex='^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$'

if [[ $command == '' ]]
then
  echo "Usage: task1 [OPTION]"
  echo "  --all     displays the IP addresses and symbolic names of all hosts in the current subnet"
  echo "  --target  scan host for open TCP ports, where --target is IP for scanning"
elif [[ $command == '--all' ]]
then
  scansubnet    
else    
  scanip
fi

