#!/bin/sh

if [ "$GCP_ENABLED" = "1" ]; then \
    sed -i 's/archive.ubuntu.com/europe-west1.gce.archive.ubuntu.com/g' /etc/apt/sources.list; \
fi

update_apt_cache

# install ppa installation support
CORE_PACKAGES="eatmydata gnupg lsb-release"
sectionText "Install core packages: $CORE_PACKAGES"
apt-get install -qq -y --no-install-recommends $CORE_PACKAGES &>> $BUILD_LOG

sectionText "Enable upstream nginx debian repository"
DIST=`lsb_release --codename --short`
curl --silent --show-error -L http://nginx.org/keys/nginx_signing.key -o - | apt-key add - &>> $BUILD_LOG
echo "deb http://nginx.org/packages/debian/ $DIST nginx" >> /etc/apt/sources.list.d/nginx.list

update_apt_cache --force
