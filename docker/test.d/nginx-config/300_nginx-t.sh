#!/bin/sh

# e.g. cronjob only container don't have apps enabled
find_sorted "$NGINX_SITES_AVAILABLE" ".conf"
[ -z "$FILES_SORTED" ] && return 0

for VHOST in $FILES_SORTED; do
    VHOST=`echo "$VHOST" | sed 's/\.conf$//g' | xargs basename`
    enable_nginx_vhost $VHOST
    sectionText "test nginx vhost $VHOST"
    nginx -t
    rm -v ${NGINX_SITES_ENABLED}/${VHOST}.conf
done
