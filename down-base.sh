#!/bin/bash

# Try to locate the IP address if not set in environment variables

. ./get-ippaddr.sh

echo "IP address is $IP_ADDR"

# load environment variables from .env
. .env

BASEMODULES='nginx-proxy dnsmasq'
for module in $BASEMODULES; do
  echo "Stopping container $module"
  docker container rm --force $module 2>/dev/null
done
