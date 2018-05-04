

# 1.0.0

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
* 

