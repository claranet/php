#!/bin/sh
sectionText "FIX: env PHP_INI_POSTMAX_SIZE to PHP_INI_POST_MAX_SIZE is set"
if [ ! -z "$PHP_INI_POSTMAX_SIZE" ]; then
    warnText "ENV var PHP_INI_POSTMAX_SIZE is deprecated, please use PHP_INI_POST_MAX_SIZE instead"
    export PHP_INI_POST_MAX_SIZE="$PHP_INI_POSTMAX_SIZE"
fi
