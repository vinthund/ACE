#!/usr/bin/env bash

# created 02112021
# created by vinthund

DAEMONNAME="MY-DAEMON"

## $$ is the process ID (PID) of the script itself
MYPID=$$
#gets  the directory path for the script
PIDDIR="$(dirname "${BASH_SOURCE[0]}")"
PIDFILE="${PIDDIR}/${DAEMONNAME}.pid"

LOGDIR="$(dirname "${BASH_SOURCE[0]}")"

#use dated logfile
#LOGFILE="${LOGDIR}/$DAEMONNAME}-$(date +"%Y-%m-%dT%H:%M:%SZ").log"
#for regular logfile
LOGFILE="${LOGDIR}/${DAEMONNAME}.log"

#log maxsize in kb
LOGMAXSIZE=1024 #1mb
RUNINTERVAL=60 #seconds

doCommands() {
#commands for daemon
	echo "running commands."
	log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": an important message or log detail..."
}

#functionality of daemon

setupDaemon() {
	#check directories work
	if [[ ! -d "${PIDDIR}" ]]; then
		mkdir "${PIDDIR}"
	fi

	if [[ ! -d "${LOGDIR}" ]]; then
		mkdir "${LOGDIR}"
	fi

	if [[ ! -f "${LOGFILE}" ]]; then
		touch "${LOGFILE}"
	else

	#check to see if logs need rotating
	SIZE=$(( $(stat --printf="%s" "${LOGFILE}") / 1024 ))
		if [[ $size -gt ${LOGMAXSIZE} ]]; then
			mv ${LOGFILE} "${LOGFILE}.$(date+%Y=%m-%dT%H-%M-%S).old"
			touch "${LOGFILE}"
		fi
	fi
}

startDaemon() {
#start the daemon 
	setupDaemon

	if ! checkDaemon; then
		echo 1>&2 "ERROR: ${DAEMONNAME} is already runnning"
		log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER already running ${DAEMONNAME} PID "$(cat ${PIDFILE})
		exit 1
	fi

	echo " * starting ${DAEMONNAME} with PID: ${MYPID}"
	echo "${MYPID}" > "${PIDFILE}"

	log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER starting up ${MYDEAMON} PID: ${MYPID}"

	loop
}

stopDaemon(){
	if ! checkDaemon; then
		echo 1>&2 " * Error: ${DAEMONNAME} is not running"
		exit 1
	fi

	echo " * stopping ${DAEMONNAME}"

	if [[ ! -z $(cat "$PIDFILE") ]]; then
		kill -9 $(cat "${PIDFILE}" &> /dev/null)
		log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER stopped ${MYDAEMON"
	else
		echo 1>&2 "cannot find PID of running daemon"
	fi
}

statusDaemon(){
	if ! checkDaemon; then
		echo " * ${DAEMONNAME} is running."
		log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER checked status - Running with PID:${MYPID}"
	else
		echo " * ${DAEMONNAME} isn't running."
		log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER checked status - Not Running."
	fi
	exit 0
}

restartDaemon(){
	#restart the daemon
	if checkDaemon; then
		#cant restart if not running
		echo "${DAEMONNAME} isn't running."
		log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER restarted"
		exit 1
	fi
	stopDaemon
	startDaemon
}

checkDaemon(){
	#check to see if daemon is running, different function to statusDaemon for other functions
	if [[ -z "${OLDPID}" ]]; then
		return 0
	elif ps -ef | grep "${OLDPID}" | grep -v grep &> /dev/null ; then
		if [[ -f "${PIDFILE}" &&$(cat "${PIDFILE}") -eq ${OLDPID} ]]; then
		#daemon is running
		return 1
	else
	#daemon isnt running
		return 0
	fi
	elif ps -ef | grep "${DAEMONNAME}" | grep -v grep | grep -v "${MYPID}" | grep -v "0:00.00" | grep bash &> /dev/null ; then
	#daemon is running but wrong pid; restart it
	log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} running with invalid PID; restarting."
	restartDaemon
	return 1
	else
	#daemon not running
		return 0
	fi
	return 1
}

loop(){
	while true; do
		doCommands
		sleep 60
	done
}

log () {
	#generic log function
	echo "$1" >> "${LOGFILE}"
}

#parse command

if [[ -f "${PIDFILE}" ]]; then
	OLDPID=$(cat "${PIDFILE}")
fi

checkDaemon

case "$1" in
	start)
		startDaemon
		;;
	stop)
		stopDaemon
		;;
	status)
		statusDaemon
		;;
	restart)
		restartDaemon
		;;
	*)
	echo 1>&2 " * Error: usage $0 {start | stop | restart | status }"
	exit 1
esac

#close program as intended
exit 0
