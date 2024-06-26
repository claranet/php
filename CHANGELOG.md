# 1.1.59 (2024-04-30)

**UPDATES**
* Update PHP version to 8.2.18
* Update PHP version to 8.3.6 but there is a bug with imagick at the moment
* Make use of Debian "bookworm"
* Adjust package mapping for bullseye and bookworm
* Increase Matomo version for test


# 1.1.58 (2022-06-29)

**UPDATES**
* Update PHP version to 8.1.7 
* Update composer to version 2.3.7
* Update several PHP extensions
* Use debian buster


# 1.1.57 (2021-08-05)

**UPDATES**
* Update PHP versions to include latest patches:
  * 7.1.33 (now stretch, before jessie)
  * 7.2.34
  * 7.3.28
* Updated NodeJS version to latest LTS v14
**IMPROVEMENTS**
* Fix the broken build at installation of NodeJS which requires
  apt-transport-https to be installed. This didn't work in older versions of 
  the php base images.
* Fix the Matomo dockerfile which was used for testing to use the images from
  the current PHP flavour which is tested. Prior it used the latest image which
  for the time being was broken at nodejs installation state and made this
  CI failing.


# 1.1.56 (2021-08-04)

**UPDATES**
* Fix the CI shell script to properly distinguish push to master/tag

# 1.1.55 (2021-08-04)

**UPDATES**
* Fix GitHub Actions by introducing new env var RELEASE_VERSION to base
  decision on it wether to publish or only build/test the image.

# 1.1.54 (2021-08-04)

**UPDATES**
* Replace TravisCI with Github Actions

# 1.1.53 (2021-08-03)

**IMPROVEMENTS**
* Fix php warning about missing libzip

# 1.1.52 (2021-05-10)

**IMPROVEMENTS**
* Patch GD installation for PHP 7.4

# 1.1.51 (2021-04-30)

**IMPROVEMENTS**
* Make image usable with debian buster. This is needed for msmtp.

# 1.1.50 (2021-04-28)

**FIXES**
* `opcache.opt_debug_level` set default of `0`

**IMPROVEMENTS**
* Make `opcache.opt_debug_level` configurable via environment variable

# 1.1.49 (2021-04-12)

**IMPROVEMENTS**
* Make default pool pm configurable via environment variables

# 1.1.48 (2020-01-19)
**UPDATES**
* PHP 7.3.13

# 1.1.47 (2020-01-19)
**UPDATES**
* PHP 7.3.12

# 1.1.46 (2020-01-19)
**UPDATES**
* PHP 7.3.11

# 1.1.45 (2020-01-19)
**UPDATES**
* PHP 7.3.10

# 1.1.44 (2020-01-19)
**UPDATES**
* PHP 7.3.9

# 1.1.43 (2020-01-19)
**UPDATES**
* PHP 7.3.8

# 1.1.42 (2020-01-19)
**UPDATES**
* PHP 7.3.7

# 1.1.41 (2020-01-19)
**UPDATES**
* PHP 7.3.6

# 1.1.40 (2020-01-19)
**UPDATES**
* PHP 7.3.5

# 1.1.39 (2020-01-19)
**UPDATES**
* PHP 7.3.4

# 1.1.38 (2020-01-19)
**UPDATES**
* PHP 7.3.3

# 1.1.37 (2020-01-19)
**UPDATES**
* PHP 7.3.2

# 1.1.36 (2020-01-19)
**UPDATES**
* PHP 7.3.1

# 1.1.35 (2020-01-18)
**UPDATES**
* PHP 7.3.0

# 1.1.34 (2020-01-17)
**UPDATES**
* PHP 7.2.26

# 1.1.33 (2020-01-17)
**UPDATES**
* PHP 7.2.25

# 1.1.32 (2020-01-17)
**UPDATES**
* PHP 7.2.24

# 1.1.31 (2020-01-17)
**UPDATES**
* PHP 7.2.23

# 1.1.30 (2020-01-17)
**UPDATES**
* PHP 7.2.22

# 1.1.29 (2020-01-17)
**UPDATES**
* PHP 7.2.21

# 1.1.28 (2020-01-17)
**UPDATES**
* PHP 7.2.20

# 1.1.27 (2020-01-17)
**UPDATES**
* PHP 7.2.19

# 1.1.26 (2020-01-17)
**UPDATES**
* PHP 7.2.18

# 1.1.25 (2020-01-17)
**UPDATES**
* PHP 7.2.17

# 1.1.24 (2020-01-17)
**UPDATES**
* PHP 7.1.33

# 1.1.23 (2020-01-17)
**UPDATES**
* PHP 7.1.32

# 1.1.22 (2020-01-17)
**UPDATES**
* PHP 7.1.31

# 1.1.21 (2020-01-17)
**UPDATES**
* PHP 7.1.30

# 1.1.20 (2020-01-17)
**UPDATES**
* PHP 7.1.29

# 1.1.19 (2020-01-17)
**UPDATES**
* PHP 7.1.28

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

