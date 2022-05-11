# check-container-status
Simply bash script to check connectivity of expected $docker_network for a defined number of containers (last ip of subnet = $last_ip) and send $email if the numbers of containers up are not the expected (declare as $expected_containers).

# usage
- To use that script you have to change variables of the script (at the start).
- User that run the script have to been on docker group, or script have to been runned as super-user.
- For automate that task add script to crontab and do it with the frecuence that you want.

# Required Packages
mailutils is needed to send mail to admin
