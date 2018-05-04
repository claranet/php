#!/bin/sh

start_services() {
  sectionHead "Starting PHPFPM"

    # first regex matches: [01-Mar-2018 17:11:29] WARNING: [pool default] child 47 said into stdout: "
    # so this is to remove the boiler plate from fpm and print only the workers message
    LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4 $FPM --nodaemonize --force-stderr 2>&1 | sed --regexp-extended \
          -e 's/^\[[0-9]{2}-[A-Za-z]{3}-20[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] WARNING: \[pool default\] child [0-9]{1,} said into std(out|err): "//g' \
          -e 's/"$//'
}

start_services
