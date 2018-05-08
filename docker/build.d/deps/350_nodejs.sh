#!/bin/sh

# NodeJS
if ! is_true "$ENABLE_NODEJS"; then
    sectionText "SKIP (enable nodejs): nodejs disabled"
    return 0
fi

sectionText "Enable upstream nodejs debian repository"
eatmydata curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | eatmydata bash - &>> $BUILD_LOG
update_apt_cache --force
install_packages --build nodejs npm

if [ ! -e "$WORKDIR/package.json" ]; then
    sectionText "SKIP (npm install): no package.json found"
    return 0
fi

npm_install ${WORKDIR}
