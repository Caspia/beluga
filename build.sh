#!/bin/bash

. ./.env

if [ ! -z "$OFFLINE" ]; then
  echo "Build not permitted with OFFLINE set to prevent destroying cached offline images"
  exit
fi

export BELUGA="1"
. ./down-base.sh

# dnsmasq: DNS server returning the base IP address for any address in a domain.
echo ""
echo "=== building dnsmasq in base beluga"
echo ""
docker image rm --force caspia/dnsmasq:alpine
docker build -t caspia/dnsmasq:alpine ./dnsmasq

for module in $MODULES; do
  echo "Starting app $module"
  cd ../$module
  ./build.sh
  cd - > /dev/null
done