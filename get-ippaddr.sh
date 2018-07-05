#!/bin/bash
#
# Determine IP address from a list of interfaces.
# This would normally be included using . ./get-ipaddr.sh rather than called

# Try to locate the IP address if not set in environment variables
if [ "$IP_ADDR" == "" ]; then
  # Choose first matching interface from a list
  for iface in eth1 enp0s3 eth0; do
    IFACE=`ls /sys/class/net | grep "\b$iface\b"`
    if [ "$IFACE" != "" ]; then
      echo "found interface $iface"
      IP_ADDR=`ip addr show $iface | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
      break
    fi
  done
fi
if [ "$IP_ADDR" == "" ]; then
  echo "IP_ADDR not set or found"
  exit 1
fi
export IP_ADDR=$IP_ADDR