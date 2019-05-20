#!/bin/bash
# Print ALL ips of the file syslog-sample and redirect to a file 'total-ips.txt'
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 > total-ips.txt
# Sort only UNIQ ips in the file

function pause(){
   read -p "$*"
}

# Initialize counters
countwcips=0;
countwcsyslog=0;
file=$1;
# Counter 'wcips' is '17'
wcips=$(sort -u total-ips.txt | wc -l)

# Counter 'wcsyslog' is 'X'
wcsyslog=$(cat syslog-sample | wc -l)

echo "Count,IP,Location"

while [ $countwcips -lt $wcips ]; do

       	total=($(sort -u total-ips.txt))
	ip=${total[$countwcips]}
#	echo "$ip"
	countipsfailed=$(grep -o -c "Failed password for root from $ip" $file)
	countips=$(grep -o -c "$ip" syslog-sample)
#	echo "$countips"
	val=$(geoiplookup $ip)
	var=$(echo "$val" | cut -b 28-40 )
#	location=${val[$1]}
	echo "--------------------------------"
	echo "PUBLIC IP: $ip"
	echo "--------------------------------"
	echo " Times in file: $countips"
	echo " Times FAILED password root: $countipsfailed"
	echo " LOCATION: $var"
	if [ $countipsfailed -ge 10 ]; then
	echo "$countipsfailed,$ip,$var" >> show-all-ips
	fi
	countwcips=$[$countwcips+1];

done
	pause "Press Enter"
	clear
	echo "Count,Ip,Location"
	echo "-----------------"
	sort -nr show-all-ips
	rm show-all-ips
