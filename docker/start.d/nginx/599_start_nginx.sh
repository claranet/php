#!/bin/sh

# start nginx in foreground to print to stdout
LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4 nginx -g 'daemon off;'
