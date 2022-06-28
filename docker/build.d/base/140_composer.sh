#!/bin/sh

php_install_composer() {
  sectionText "Download PHP composer"
  curl -sS -o /tmp/composer-setup.php https://getcomposer.org/installer
  curl -sS -o /tmp/composer-setup.sig https://composer.github.io/installer.sig
  eatmydata $PHP -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

  sectionText "Install PHP composer"
  eatmydata $PHP /tmp/composer-setup.php --install-dir=/usr/bin/ --version=$COMPOSER_VERSION --filename=composer &>> $BUILD_LOG

  sectionText "Change git transport from SSH to HTTPS ..."
  eatmydata composer config --global github-protocols https &>> $BUILD_LOG
}

php_install_composer
