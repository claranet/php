#!/bin/sh

sectionText "Start crond"
busybox crond -f -l 1 -L /dev/stdout
