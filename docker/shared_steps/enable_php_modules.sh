#!/bin/sh

[ ! -z "${PHP_EXTENSIONS_STARTUP_ENABLE}" ] || return 0

for ext in $PHP_EXTENSIONS_STARTUP_ENABLE; do
    sectionText "Enable PHP extension $ext"
    normalized_ext=`echo "$ext" | cut -d- -f1 | tr '[:upper:]' '[:lower:]'`
    docker-php-ext-enable $normalized_ext
    if [ -e "/usr/local/etc/php/mods-available/$normalized_ext.ini" ]; then
        ln -fs /usr/local/etc/php/mods-available/$normalized_ext.ini /usr/local/etc/php/conf.d/20-$ext.ini
    fi
    mkdir -pv /tmp/$ext
    chmod -v 7777 /tmp/$ext
done