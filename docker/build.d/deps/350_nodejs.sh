#!/bin/sh

if [ ! -e "$WORKDIR/package.json" ]; then
    sectionText "SKIP: no package.json found"
    return 0
fi

npm_install ${WORKDIR}
