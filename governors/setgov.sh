#! /usr/bin/env bash
#created by vinthund
#26102021
#version 0.0.1

AUTHOR="vinthund"
VERSION="0.0.1"
CREATED="26102021"

GOVDIR="/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
AVAILGOVS=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)

while [[ 1 ]]; do
	echo "please select from the following governors:"
	echo "${AVAILGOVS}"

	read GOV
	#use grep to match input with substring of AVAILGOVS
	if grep -q "$GOV" <<< "${AVAILGOVS}"; then
		break
	fi
done

echo -n "Chnging the scaling_governor for CPU 0 1 2 3 to "
echo "${GOV}" | sudo tee ${GOVDIR}
echo "Success! Your new Scaling Governor is ${GOV}" 
