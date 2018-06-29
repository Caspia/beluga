#!/bin/bash

# creates a merged docker-compose file, and runs docker-compose
#
# usage:
#   ./merge-compose.sh ACTION
# where ACTION in build, up, down, etc.
#

if [ "$1" == "" ]; then
    echo "Usage: ./merge-compose.sh ACTION"
    echo "example: ./merge-compose up"
    exit 1
fi

# merge in the environment variables
. ./.env

# default for DOMAIN is .ed"
if [ "$DOMAIN" == "" ]; then
  DOMAIN=".ed"
fi
echo "DOMAIN is $DOMAIN"
export DOMAIN=$DOMAIN

# Try to locate the IP address if not set in environment variables
if [ "$IP_ADDR" == "" ]; then
  # Choose first matching interface from a list
  for iface in eth1 enp0s3 eth0; do
    if [ `ls /sys/class/net | grep "\b$iface\b"` != "" ]; then
      echo "found interface $iface"
      IP_ADDR=`ip addr show $iface | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
      echo "IP address is $IP_ADDR"
      break
    fi
  done
fi
if [ "$IP_ADDR" == "" ]; then
  echo "IP_ADDR not set or found"
  exit 1
fi
export IP_ADDR=$IP_ADDR

# Merge the docker-compose files into a single .docker-compose.yml
cp docker-compose-base.yml .docker-compose.yml

MODULES="hello"
for module in $MODULES; do
  cat "../$module/docker-compose-append.yml" >> ".docker-compose.yml"
done

OPTIONS=""
if [ "$1" == "up" ]; then
  OPTIONS="-d --remove-orphans --force-recreate"
fi
docker-compose -f ".docker-compose.yml" "$1" $OPTIONS