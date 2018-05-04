#!/bin/bash

# docs: https://matomo.org/faq/how-to-install/faq_18271/

sectionText "Fetch matomo sources version $MATOMO_VERSION"
git clone --depth 1 --branch $MATOMO_VERSION --single-branch --config filter.lfs.smudge=true https://github.com/matomo-org/matomo.git /app.source &>> $BUILD_LOG
rm -rf /app.source/.git
mv /app.source/* ${WORKDIR}/
mv /app.source/.[a-z]* ${WORKDIR}/
