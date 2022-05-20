# check-container-status
Simply bash script to check connectivity of expected $docker_network for a defined number of containers (last ip of subnet = $last_ip) and send $email if the numbers of containers up are not the expected (declare as $expected_containers).

# Usage
- To use that script you have to change variables on the script (at the start).
  - $docker_network (network to analyze).
  - $firts_ip (firts ip of the network).
  - $email (email to send alerts).
  - $expected_containers (number of containers expected on $docker_network).
- For automate that task add script to crontab and do it with the frecuence that you want.
- Additionally you can remove echo msgs on script to cleaner output.
- By default alerts go to spam folder, just declare this alerts as no spam.

# Required Packages
- mailutils. 
  - $ apt-get update && apt-get install mailutils

# To Do
- Looking for some way to send alerts to email as no spam.

# Misc
- Author: m0rfeo
- Special Thanks to: Diego Fernandez Raposo

I'm open to suggestions about how make the process more elegant and efficient :)
