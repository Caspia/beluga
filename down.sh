#!/bin/bash

# script file to stop base beluga services and supported apps.

# start base services. This also loads environment variables from .env
. ./down-base.sh

# loop through enabled services and stop

export BELUGA="1"
export OFFLINE=$OFFLINE

for module in $MODULES; do
  echo "Stopping container $module"
  cd ../$module
  ./down.sh
  cd - > /dev/null
done
