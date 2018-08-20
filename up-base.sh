#!/bin/bash

# script file to start base beluga containers.

# remove and recreate the beluga network
docker network rm beluga 2> /dev/null
docker network create \
  --subnet=172.20.0.0/20 \
  --ip-range=172.20.1.0/24 \
  -o "" \
  beluga

# default for DOMAIN is .ed"
if [ "$DOMAIN" == "" ]; then
  DOMAIN=".ed"
fi
echo "DOMAIN is $DOMAIN"
export DOMAIN=$DOMAIN

# nginx-proxy: maps url names to specific docker containers
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --name nginx-proxy \
  --network="beluga" --restart=always jwilder/nginx-proxy:alpine

# dnsmasq: DNS server returning the base IP address for any address in a domain.
if [ -z "$OFFLINE" ]; then
  docker build -t caspia/dnsmasq:alpine ./dnsmasq
fi
echo "IP_ADDR is ${IP_ADDR}"
echo "DNSMASQ_EXTRA is ${DNSMASQ_EXTRA}"
docker run -p 53:53/tcp -p 53:53/udp -d --network="beluga" --restart=always --cap-add NET_ADMIN \
  --name dnsmasq caspia/dnsmasq:alpine "-A" "/${DOMAIN}/${IP_ADDR}" "${DNSMASQ_EXTRA}"
