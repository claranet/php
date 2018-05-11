#!/bin/sh


if [ ! -e "composer.json" ]; then
  sectionText "SKIP: no composer.json file found"
  return 0
fi

sectionText "optimize autoloader with composer dumpautoload $COMPOSER_DUMP_ARGS"
composer dumpautoload $COMPOSER_DUMP_ARGS


