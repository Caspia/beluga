#!/bin/bash

# load environment variables from .env
. .env

BASEMODULES='nginx-proxy dnsmasq'
for module in $BASEMODULES; do
  echo "Stopping container $module"
  docker container rm --force $module 2>/dev/null
done
