#!/bin/sh

if ! is_true $ENABLE_BOWER; then
    sectionText "SKIP: bower is disabled"
    return 0
fi

npm_install ${WORKDIR} --global bower

if [ -e "$WORKDIR/bower.json" ]; then
    sectionText "Run bower install"
    bower install --allow-root &>> $BUILD_LOG
else
    sectionText "SKIP: no bower.json found"
fi
