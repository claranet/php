# 1.1.18 (2019-03-21)
**UPDATES**
* PHP 7.1.27 and 7.2.16

# 1.1.17 (2019-03-21)

**FIXES**
* fix using the cronjob start job within docker-compose (it fails to start after a previous shutdown/stop)

# 1.1.16 (2019-03-01)
**UPDATES**
* PHP 7.2.15

# 1.1.15 (2019-02-05)
**UPDATES**
* PHP 7.1.26 and 7.2.14

# 1.1.14 (2018-10-17)

**FIXES**
* fix name of env var `PHP_INI_POST_MAX_SIZE` ( from `PHP_INI_POSTMAX_SIZE` ), the old version still works but will be removed with version 2.0.0

# 1.1.13 (2018-10-16)

**UPDATES**
* PHP 7.1.23 and 7.2.11

# 1.1.12 (2018-10-10)

**FIXES**
* fix enable PHP Modules on start

# 1.1.11 (2018-10-08)

**FIXES**
* fix installing php ldap extension

# 1.1.10 (2018-08-10)

**UPDATES**
* PHP 7.1.20 and 7.2.8

# 1.1.9 (2018-06-07)

**FIXES**
* allow users to change the PHP opcache optimization level

# 1.1.8 (2018-06-07)

**UPDATES**
* PHP 7.1.18 and 7.2.6
* matomo example matomo version 3.5.1

# 1.1.7 (2018-05-23)

**FIXES**
* wait\_for\_tcp\_service timeout calculation

# 1.1.6 (2018-05-22)

**FIXES**
* include multiple docker/\*.inc.sh files

**IMPROVEMENTS**
* let bump2version also push tags / commits

# 1.1.5 (2018-05-17)

**FIXES**
* remove deprecated docker/bin/gen\_crontab.php (spryker specific)

# 1.1.4 (2018-05-17)

**FIXES**
* make example/matomo work on localhost via docker-compose


# 1.1.3 (2018-05-15)

**FIXES**
* remove matomo build from CI tests

# 1.1.2 (2018-05-15)
**FIXES**
* Create the folder /var/spool/cron/crontabs needed by crond
* Move function `enable_cron_configs` above in the script

# 1.1.1 (2018-05-11)

**UPDATES**
* PHP 7.1.17 (from 7.1.16)

**FIXES**
* fix nodejs installation for PHP 7.1.x flavour (debian jessie has npm within the nodejs package)

# 1.1.0 (2018-05-11)

**IMPROVEMENTS**
* add step in `build > deps` to run composer dumpautoload optimizations
* introduce `$COMPOSER_DUMP_ARGS`, `$COMPOSER_VERSION` env vars
* use the `example/matomo` reference image for tests as well
* bump example/matomo matomo version to 3.5.0
* simplify matomo fetch and install process in example/matomo
* make composer version configurable

**FIXES**
* local builds for the base image were missing the PHP version in their docker tag
* don't install composer package `hirak/prestissimo` in base AND deps; base is sufficient
* don't drop packages.json/lock / composer.json/lock files in image clean up step
* fix ERROR_EXIT_CODE isn't working

# 1.0.5 (2018-05-08)

* fix missing `npm` in PATH ( github issue #5 )

# 1.0.4 (2018-05-08)

* fix travis ci release step bash script
* adds bump2version

# 1.0.3 (2018-05-08)

* just introduced to trigger CI again

# 1.0.2 (2018-05-08)

* fix error message BG color for build steps using `errorText`
* fix CI matrix and stages by introducing a special `bin/ci.sh` script


# 1.0.1 (2018-05-04)

* fix travis ci


# 1.0.0 (2018-05-04)

https://github.com/claranet/spryker-base will be considered to be the previous version of 1.0.0!

This is an overall revision of the previous `spryker-base` concept. It is generalized and lessons learned.

So this release changes:

* default variables now solely resides in the `Dockerfile`, so `build.conf.sh` and `defaults.inc.sh` are gone
* instead of having fixed `/entrypoint.sh` arguments, they are building themselves up based on the
  directory-structure in `docker/`
* we support a generic crond and a pre/post deployment start command
* nginx and phpfpm are now designed to be started in different containers but from the same docker image
  This is required in order to not having logs meshed up by phpfpm and nginx (same line gets written by
  nginx and phpfpm at the same time)
* provide a generic nginx and php-fpm config (no special vhost domain, no special php-fpm pool name)
* nginx php-fpm host/port is configured via envsubst

