#!/bin/sh

if [ -z "$SYSTEM_PACKAGES" ]; then
    sectionText "SKIP: no system packages to be installed"
    return 0
fi

# FIXME: postgresql-client installation is missing /usr/share/man/man[1,7]
mkdir -p /usr/share/man/man1 /usr/share/man/man7

install_packages $SYSTEM_PACKAGES
