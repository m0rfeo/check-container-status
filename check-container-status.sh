#!/bin/bash

#--------------------------------------------------------------------------------------- README ---------------------------------------------------------------------------------------#
# GNU GENERAL PUBLIC LICENSE                                                                                                                                                           #
#                       Version 3, 29 June 2007                                                                                                                                        #
#                                                                                                                                                                                      #
# Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>                                                                                                                 #
# Everyone is permitted to copy and distribute verbatim copies                                                                                                                         #
# of this license document, but changing it is not allowed.                                                                                                                            #
#                                                                                                                                                                                      #
# Author: M0rfeo                                                                                                                                                                       #
#																						       #
# This script check connectivity of expected $docker_network for a defined number of containers (last ip of subnet = $last_ip) and send $email if the numbers of containers up are not #
# the expected (declare as $expected_containers).																       #
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#vars
docker_network=172.18.0
firts_ip=2 #0.1 is GW
last_ip=7 #last expected ip of network
email="email@gmail.com"
expected_containers=6

#Ping on expected subnet
while [ $firts_ip -le $last_ip ]
do
	ping -c 1 -q $docker_network.$firts_ip >> /tmp/ping-containers
	let firts_ip=$firts_ip+1
done

#Get number of containers running
cat /tmp/ping-containers | grep packets | sort | uniq -c | sed -r 's/\s+//g' | cut -c1-1 > /tmp/num-containers-running

#Check number of containers running and if are less than 6 send email to admin
num=$(cat /tmp/num-containers-running)

if [ $num -eq $expected_containers ];
then
	echo CHECK-CONTAINER-STATUS [DONE] - All containers on network are running
else
	echo CHECK-CONTAINER-STATUS [FAIL] - Sending mail to admin...
	#Send email from $email to $email with -s subject and <<< body
	mail -aFrom:$email -s "Cluster down" $email <<< "Something wrong";
fi

#Delete tmp file created
rm /tmp/ping-containers
rm /tmp/num-containers-running
