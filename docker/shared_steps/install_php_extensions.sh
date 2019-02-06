#!/bin/sh

if [ -z "$PHP_EXTENSIONS" ]; then
  sectionText "SKIP: no extensions given"
  return 0
fi

php_install_gd() {
  eatmydata docker-php-ext-configure $ext --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
  eatmydata docker-php-ext-install -j$COMPILE_JOBS $ext
}

php_install_ldap() {
  local php_version=$($PHP --version | head -n1 | cut -d " " -f 2 | cut -d . -f 1,2)
  if [ $php_version = "7.0" ]; then
    install_packages --build "libldb-dev"
    ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so
  fi
  sectionText "Use core install"
  eatmydata docker-php-ext-install -j$COMPILE_JOBS $ext &>> $BUILD_LOG
}

php_install_extensions() {
  local extensions="$*"
  install_packages --build $PHP_BUILD_PACKAGES
  eatmydata docker-php-source extract
  
  local already_installed_extensions=`php -m | egrep '^([A-Za-z_]+)$' | tr '[:upper:]' '[:lower:]'`
  local php_extensions_count=`echo $extensions | wc -w`
  local php_extensions_counter="1"
  
  for ext in $extensions; do
    sectionText "Install PHP extension ($php_extensions_counter/$php_extensions_count) $ext"
    local normalized_ext=`echo "$ext" | cut -d- -f1 | tr '[:upper:]' '[:lower:]'`
    if ! is_in_list $normalized_ext "$already_installed_extensions" &>> $BUILD_LOG; then
      # if there is a special function to install the extension, use it
      # if this extension is a core extension, use docker-php-ext-install
      # else try to install the extension from pecl
      if type php_install_$normalized_ext &>> $BUILD_LOG; then
        sectionText "Use special install function: php_install_$normalized_ext"
        php_install_$normalized_ext &>> $BUILD_LOG
      elif [ -d "/usr/src/php/ext/$normalized_ext" ]; then
        sectionText "Use core install"
        eatmydata docker-php-ext-install -j$COMPILE_JOBS $ext &>> $BUILD_LOG
      else
        sectionText "Use pecl"
        eatmydata pecl install $ext &>> $BUILD_LOG
      fi

      if ! is_in_list $normalized_ext "$PHP_EXTENSIONS_STARTUP_ONLY" &>> $BUILD_LOG; then
        sectionText "Enable extension"
        docker-php-ext-enable `echo $ext | tr '[:upper:]' '[:lower:]' | cut -d- -f1` &>> $BUILD_LOG
      fi
    else
      sectionText "SKIP: already installed"
    fi
    let 'php_extensions_counter += 1'
  done
  
  docker-php-source delete
}

php_install_extensions $PHP_EXTENSIONS
