#!/bin/sh

# prevents doing init twice

if is_init_done; then
    exit 0
fi
