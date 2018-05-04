#!/bin/sh

# TODO: test, as this is not tested!
# see https://docs.newrelic.com/docs/agents/php-agent/installation/php-agent-installation-tar-file
install_newrelic() {
    local tmp_dir=`mktemp -d`
    cd $tmp_dir
    curl -o -L - https://download.newrelic.com/php_agent/release/newrelic-${NEWRELIC_PHP_VERSION}-linux.tar.gz | tar -xf -
    cd newrelic-$NEWRELIC_PHP_VERSION/
    eatmydata ./newrelic-install
}

if is_true "${ENABLE_NEWRELIC}"; then
    sectionText "Install newrelic"
    install_newrelic &>> $BUILD_LOG
else
    sectionText "SKIP: disabled"
fi
