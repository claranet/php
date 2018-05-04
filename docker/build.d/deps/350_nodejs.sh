#!/bin/sh

# NodeJS
if is_true "$ENABLE_NODEJS"; then
    sectionText "Enable upstream nodejs debian repository"
    eatmydata curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | eatmydata bash - &>> $BUILD_LOG
fi

update_apt_cache --force

if [ ! -e "$WORKDIR/package.json" ]; then
    sectionText "SKIP: no package.json found"
    return 0
fi

npm_install ${WORKDIR}
