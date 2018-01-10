#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Source our credentials
. /root/openrc

# Check the status of the cinder-volume service
echo "Checking for down services..."

down_service_list=''
down_service_list=$(cinder service-list | awk -F\| '/cinder-volume/ && /down/ {print $3":"$2}' | tr -d ' ')

# If down_service_list isn't empty, a service is down, we need to determine which one it is and bounce it
if [ "$down_service_list" != '' ];then
   export IFS=$'\n'
   for i in $(echo $down_service_list); do
      echo "Found down cinder service $(echo $i | cut -d\: -f2) on host $(echo $i | cut -d\: -f1 | cut -d\@ -f1). Restarting..."
      ssh $(echo $i | cut -d\: -f1 | sed 's/-cinder-volumes-container/_cinder_volumes_container/' | cut -d\@ -f1) "service $(echo $i | cut -d\: -f2) restart"
      echo "Done..."
   done
fi
