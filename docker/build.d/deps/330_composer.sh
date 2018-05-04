#!/bin/sh

[ -e "$WORKDIR/composer.json" ] || return 0

sectionText "Run composer install"
PHP_INI_ALLOW_URL_FOPEN=yes eatmydata composer global require hirak/prestissimo &>> $BUILD_LOG
PHP_INI_ALLOW_URL_FOPEN=yes eatmydata composer install --prefer-dist $COMPOSER_ARGS &>> $BUILD_LOG
