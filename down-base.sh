#!/bin/bash

# load environment variables from .env
. .env

docker container rm --force nginx-proxy dnsmasq
