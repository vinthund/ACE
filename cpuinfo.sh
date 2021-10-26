#! /usr/bin/env bash
#created by vinthund
#26102021
#version 0.0.1

NTHCORE=$(lscpu|awk 'NR==3 {print $2}')

echo "                   CORE 0    CORE 1    CORE 2    CORE 3"

for i in /sys/devices/system/cpu/cpu0/cpufreq/{cpuinfo,scaling}_*; do #iterate over all the cpu freq
	PNAME=$(basename $i)
	[[ "${PNAME}" == *available* ]] || [[ "${PNAME}" == *transition* ]] || \
	[[ "${PNAME}" == *driver* ]] || [[ "${PNAME}" == *setspeed* ]] && continue

	echo "$PNAME: "

	for (( j = 0; j < ${NTHCORE}; j++ ));do
		KPARAM=$(echo $i | sed "s/cpu0/cpu$j/") #replace cpu0 with cpuj for .../cpu/cpuj/cpufreq....
		sudo cat $KPARAM
	done
done | paste - - - - - | column -t
