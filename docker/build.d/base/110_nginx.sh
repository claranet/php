#!/bin/sh

sectionText "Remove nginx config comming from APT"
rm -rf /etc/nginx

sectionText "Prepare access/error log to send to stdout/stderr"
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
