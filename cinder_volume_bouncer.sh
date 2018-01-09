#!/bin/bash

# Source our credentials
. /root/openrc

# Check the status of the cinder-volume service
down_service_list=$(cinder service-list | awk -F\| '/cinder-volume/ && /down/ {print $3":"$2}' | tr -d ' ')

# If down_service_list isn't empty, a service is down, we need to determine which one it is and bounce it
if [ "$down_service_list" != '' ];then
   export IFS=$'\n'
   for i in $(echo $down_service_list); do
      ssh $(echo $i | cut -d\: -f1 | sed 's/-cinder-volumes-container/_cinder_volumes_container/') "service $(echo $i | cut -d\: -f2) restart)"
   done
fi
