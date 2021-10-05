#author: vinthund
#released: 05102021
#version: 0.0.1
AUTHOR="vinthund"
RELEASED="05102021"
VERSION="0.0.1"
#display help message

USAGE(){
	echo -e $1
	echo -e "Usage: systemstats [-t temperature] [-i ipv4 address]"
	echo -e "[-v version]"
	echo -e "more information see man systemstats"
}
#check for arguments error checking
if [ $# -lt 1 ];then
	USAGE "not enough arguements"
elif [ $# -gt 3 ];then
        USAGE "too many arguments"
        exit 1
elif [[ ( $# == '-h' ) || ($1 == '--help' ) ]];then
        USAGE "Help!"
        exit 1
fi

#frequently scripts are written so that arguments can be passed in any order us$
#with the flags method some arguments can be made mandatory or optional 
#example: a:b (a is mandatory, b is optional) abc is all optional 
while getopts tiv OPTION 
do 
case ${OPTION}
in 
i) ipconfig wlan0 |  grep -w inet |  awk '{print$2}')
	echo ${IP}
v) echo -e "systemStats:\n\t Version: ${VERSION} Released: ${RELEASED} Author: ${AUTHOR}";;
t) TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
   echo ${TEMP} "need to divide by thousand";;
esac
done

#end of script

