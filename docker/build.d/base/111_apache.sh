#!/bin/sh

sectionText "Remove unused Apache configs comming from APT"
rm -f /etc/apache2/conf-enabled/other-vhosts-access-log.conf 
rm -f /etc/apache2/conf-available/other-vhosts-access-log.conf 
rm -f /var/log/apache2/other_vhosts_access.log 
rm -f /etc/apache2/sites-enabled/000-default.conf 
rm -f /etc/apache2/sites-available/000-default.conf 
rm -f /etc/apache2/sites-available/default-ssl.conf

sectionText "Enable default used Apache Modules"
ln -fs /etc/apache2/mods-available/proxy.* /etc/apache2/mods-enabled/
ln -fs /etc/apache2/mods-available/proxy_fcgi.* /etc/apache2/mods-enabled/

sectionText "Prepare access/error log to send to stdout/stderr"
ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stderr /var/log/apache2/error.log