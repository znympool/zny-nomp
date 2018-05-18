#!/bin/sh

KNOMP_DIR=/usr/local/zny-nomp
PIDFILE="/var/lock/subsys/zny-nomp"
ERRORFILE=${KNOMP_DIR}/errorPayment.txt

TIMESTAMP=`date`

case "$1" in
start)
  if [ -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : zny-nomp is already running"
    exit 1
  fi
  echo "${TIMESTAMP} : Starting zny-nomp"
  cd ${KNOMP_DIR}
  /usr/local/bin/npm start > /var/log/zny-nomp.log 2>&1 &
  echo $! > ${PIDFILE}
;;

stop)
  if [ ! -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : zny-nomp is not running"
    exit 1
  fi
  PID=`cat ${PIDFILE}`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  RET=`kill ${PID}`

  echo "${TIMESTAMP} : Stopping zny-nomp"

  rm ${PIDFILE}
;;

restart)
  $0 stop
  sleep 10
  $0 start
;;

*)
  if [ ! -f  ${ERRORFILE} ]; then
    echo "${TIMESTAMP} : END"
    exit 1
  fi

  rm ${ERRORFILE}

  $0 stop
  sleep 10
  $0 start

  echo "${TIMESTAMP} : Error Restart"
  exit 1

;;

esac
