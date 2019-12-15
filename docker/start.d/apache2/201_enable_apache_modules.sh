#!/bin/sh

if [ -z "$APACHE_MODS_ENABLE" ]; then
  sectionText "SKIP: no Modules given"
  return 0
fi

apache2_enable_modules() {
    local modules="$*"
    for mod in $modules; do
        ln -sf /etc/apache2/mods-available/$mod.* /etc/apache2/mods-enabled/
    done
}

apache2_enable_modules $APACHE_MODS_ENABLE