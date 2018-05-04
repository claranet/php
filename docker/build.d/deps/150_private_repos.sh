#!/bin/sh

if [ ! -z "${GITLAB_SERVER_NAME}" ]; then
    sectionText "enable basic auth for ${GITLAB_SERVER_NAME}"
    echo -e "machine ${GITLAB_SERVER_NAME}\nlogin ${GITLAB_USER}\npassword ${GITLAB_TOKEN}" >> ~/.netrc
else
    sectionText "SKIP: no gitlab url set"
    return 0
fi
