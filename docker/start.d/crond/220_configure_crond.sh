#!/bin/bash

files_sorted "/etc/cron.d"
if [ -z "$FILES_SORTED" ]; then
    sectionText "SKIP: no cron config files found in /etc/cron.d/"
    return 0
fi

enable_cron_configs() {
    for i in $FILES_SORTED; do
        local filename=$(basename $i)
        sectionText "Enable cron config $filename"
        ln -vs $i /var/spool/cron/crontabs/$filename &>> $BUILD_LOG
    done
}


