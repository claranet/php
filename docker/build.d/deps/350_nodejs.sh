#!/bin/sh

# NodeJS
if ! is_true "$ENABLE_NODEJS"; then
    sectionText "SKIP (enable nodejs): nodejs disabled"
    return 0
fi

sectionText "Enable upstream nodejs debian repository"
# The following line is for allowing to fetch apt-transport-https from buster-updates
# As the requirement to install apt-transport-https comes from below nodejs bash
# script we're not able to pin to a specific version of apt-transport-https to avoid this issue.
sed -i '2,2s/buster/buster*/' /etc/apt/preferences.d/argon2-buster
eatmydata curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | eatmydata bash - &>> $BUILD_LOG
# Undo the above modifiaction to only allow this for this use-case
sed -i '2,2s/buster*/buster/' /etc/apt/preferences.d/argon2-buster
update_apt_cache --force
install_packages --build nodejs npm

if [ ! -e "$WORKDIR/package.json" ]; then
    sectionText "SKIP (npm install): no package.json found"
    return 0
fi

npm_install ${WORKDIR}
