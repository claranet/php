#!/bin/bash

enable_cron_configs() {
    sectionText "Creating crond folder"
    mkdir -p /var/spool/cron/crontabs
    for i in $FILES_SORTED; do
        local filename=$(basename $i)
        sectionText "Enable cron config $filename"
        ln -vfs $i /var/spool/cron/crontabs/$filename &>> $BUILD_LOG
    done
}


find_sorted "/etc/cron.d"
if [ -z "$FILES_SORTED" ]; then
    sectionText "SKIP: no cron config files found in /etc/cron.d/"
    return 0
else
    enable_cron_configs
fi
