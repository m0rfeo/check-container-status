#!/bin/bash

#--------------------------------------------------------------------------------------- README ---------------------------------------------------------------------------------------#
# GNU GENERAL PUBLIC LICENSE                                                                                                                                                           #
#                       Version 3, 29 June 2007                                                                                                                                        #
#                                                                                                                                                                                      #
# Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>                                                                                                                 #
# Everyone is permitted to copy and distribute verbatim copies                                                                                                                         #
# of this license document, but changing it is not allowed.                                                                                                                            #
#                                                                                                                                                                                      #
# Author: m0rfeo																				       #
# Thanks to: Diego Fernandez Raposo                                                                                                                                                    #
#																						       #
# This script check connectivity of expected $docker_network for a defined number of containers (last ip of subnet = $last_ip) and send $email if the numbers of containers up are not #
# the expected (declare as $expected_containers).																       #
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#vars
docker_network=172.18.0
firts_ip=2
email="foo@email.com"
expected_containers=6 #Number of expected containers on the network to analyze
last_ip=$(($firts_ip + $expected_containers -1)) #auto calc the last ip of subnet

#Just to check variables
echo "Loading script..."
echo "Loading variables... "
echo " -------------------------------------------------------"
echo "|			VARIABLES			|"
echo "|							|"
echo "| - Expected Containers --> $expected_containers 				|"
echo "| - Docker Network -------> $docker_network.0/16 		|"
echo "| - Firts IP -------------> $firts_ip	       			|"
echo "| - Last ip --------------> $last_ip	       			|"
echo "| - Admin Mail -----------> $email		|"
echo " -------------------------------------------------------"

#Function ping with output 0/1
fping() {
  ping -q -c 1 -W .02 -q $1 &>/dev/null
  return $?;
};
#Function to print info into array with Ips on docker_network and Status (UP/DOWN)
printIps() {
	echo "-----------------"
        for key in "${!containerStatus[@]}"; do
                printf '%s = %s\n' "$key" "${containerStatus[$key]}"
        done
        echo "-----------------"
};

#Associative Array to keep track on analyzed containers
declare -A containerStatus
# Variable to count Up Containers
declare num=0;

#Scan to all subnet range
echo "Starting scan..."
while [ $firts_ip -le $last_ip ]
do
	fping $docker_network.$firts_ip
	if [ $? -eq 0 ];
	then
	  containerStatus[$docker_network.$firts_ip]="UP";
	  let num=num+1 #+1 container up
	else
	  containerStatus[$docker_network.$firts_ip]="DOWN";
	fi

	let firts_ip=$firts_ip+1 #Next IP on subrange
done

if [ $num -eq $expected_containers ];
then
	echo "CHECK-CONTAINER-STATUS [SUCESS] - Expected number of containers ($expected_containers) on $docker_network.0/16 :)"
	printIps
else
	echo "CHECK-CONTAINER-STATUS [FAIL] - Less of $expected_containers containers on $docker_network.0/16 :("
	printIps
	echo "Seding mail to $email..."
	#Send email from $email to $email with -s subject and <<< body
	mail -aFrom:$email -s "Cluster down" $email <<< "Something wrong";
fi
