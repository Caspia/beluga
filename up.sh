#!/bin/bash

# script file to start base beluga services and supported apps.

# kill and remove any previous containers
. ./down.sh

# start base services. This also loads environment variables from .env
. ./up-base.sh

# loop through enabled services and start

export BELUGA="1"
export OFFLINE=$OFFLINE

for module in $MODULES; do
  echo "Starting app $module"
  cd ../$module
  . ./up.sh
  cd - > /dev/null
done
