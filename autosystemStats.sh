#! /usr/bin/env bash
#author: vinthund
#released: 19102021
#version: 0.0.1
AUTHOR="vinthund"
RELEASED="19102021"
VERSION="0.0.1"
FILE=~/ACE/systemstats.log
#display help message

USAGE(){
	echo -e $1
	echo -e "Usage: systemstats [-v version]"
	echo -e "more information see man systemstats"
}
#check for arguments error checking
if [ $# -gt 1 ];then
	USAGE "not enough arguements"
        exit 1
elif [[ ( $# == '-h' ) || ($1 == '--help' ) ]];then
        USAGE "Help!"
        exit 1
elif [[ $1 == '-v' ]]; then
	echo -e " ${NOW}\t{IP: ${IP} Temperature: ${TEMP} CPU:${USAGE}" >> ${FILE}
	exit 1
fi
#variables for system information
IP=$(ifconfig wlan0 |  grep -w inet |  awk '{print$2}')
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
USAGE=$(grep -w 'cpu' /proc/stat | awk '{usage=($2+$3+$4+$6+$7+$8)*100/($2+$3+$4+$5+$6+$7+$8)}
					   {free=($5)*100/($2+$3+$4+$5+$6+$7+$8)}
					   END  {printf "used CPU: %.2f%%",usage}
					        {printf " Free CPU: %.2f%%",free}')
NOW=$(date +%FT%TZ)
#ouput to log file
echo -e " ${NOW}\t{IP: ${IP} Temperature: ${TEMP} CPU:${USAGE}" >> ${FILE}
#end of script
