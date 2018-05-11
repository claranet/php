#!/bin/sh

if [ ! -e "$WORKDIR/composer.json" ]; then
    sectionText "SKIP (composer install): no composer.json file found"
    return 0
fi

sectionText "Run composer install"
PHP_INI_ALLOW_URL_FOPEN=yes eatmydata composer install --prefer-dist $COMPOSER_ARGS &>> $BUILD_LOG
