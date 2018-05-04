#!/bin/sh


# this script reloads the php-fpm. While reloading, opcache and apcu will get purged.

PID_FILE="/run/php/${FPM}.pid"

if [ -f $PID_FILE ]; then
  FPM_PID=`cat $PID_FILE`
else
  FPM_PID=`ps x | grep "php-fpm: master" | head -n 1 | egrep -o '(^ *[0-9]+)'`
fi

kill -s SIGHUP $FPM_PID
