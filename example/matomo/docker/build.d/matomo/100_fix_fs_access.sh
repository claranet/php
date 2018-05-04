#!/bin/bash

sectionText "Create ${WORKDIR}/tmp"
mkdir -p ${WORKDIR}/tmp

sectionText "Make www-data owner of all files in ${WORKDIR}/tmp and ${WORKDIR}/config"
chown -R www-data: ${WORKDIR}/tmp ${WORKDIR}/config

sectionText "Matomo recommends that ${WORKDIR}/piwik.js is writeable as well, so fix that"
chown www-data: ${WORKDIR}/piwik.js
