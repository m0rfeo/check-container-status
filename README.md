# check-container-status
Simply bash script to check connectivity of expected $docker_network for a defined number of containers (last ip of subnet = $last_ip) and send $email if the numbers of containers up are not the expected (declare as $expected_containers).

# Usage
- To use that script you have to change variables of the script (at the start).
- For automate that task add script to crontab and do it with the frecuence that you want.

# Required Packages
mailutils is needed to send mail to admin

# Misc
Author: m0rfeo 

I'm open to suggestions about how make the process more elegant and efficient :)
