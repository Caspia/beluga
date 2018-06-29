#!/bin/bash

# script file to start base beluga containers.

# load environment variables from .env
. .env

# kill and remove any previous containers
./down-base.sh

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

# nginx-proxy: maps url names to specific docker containers
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --name nginx-proxy --network="beluga" --restart=always jwilder/nginx-proxy:alpine

# dnsmasq: DNS server returning the base IP address for any address in a domain.
docker build -t caspia/dnsmasq:alpine ./dnsmasq
docker run -p 53:53/tcp -p 53:53/udp -d --network="beluga" --restart=always --cap-add NET_ADMIN --name dnsmasq caspia/dnsmasq:alpine "-A" "/${DOMAIN}/${IP_ADDR}"
