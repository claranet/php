
* check how to install newrelic on php image?
* check how to install blackfire
* check php modules duplicate loading

* add a way to configure service dependencies by ENV var
    So e.g. we support launching crond / jenkins / phpfpm after we can reach
    the given addresses. Possible map syntax: `smtp.my.domain:2525/600` where
    the `600` specifies an optional timeout in seconds.
    Default timeout should be 600.
* add a way to configure an alternate phpfpm IP address
    Required for docker-compose environemnts, so phpfpm can be accessed by its
    service name; instead of looking at `127.0.0.1`.
    Check if we need to configure a nginx resolver for this to work?
* integrate php phan checks in `test` section - https://github.com/phan/phan
* add php linting `test`
* add a generic netrc BUILD_ARG in ONBUILD, to support even more scenarios

* add opencensus PHP extension + docs about how to integrate it
* add NPM_CONFIG_REGISTRY support (and docs about how to use your own npm registry); same for composer (via ONBUILD)

* document how to extend php ini with own files
* docuemnt how to extend nginx config
* renumber steps with more room for injections

# Examples

* entry:  helo world
* medium: claranet/matomo
* expert: claranet/spryker-demoshop

# Minor versions

* add generic args to support github / gitlab / bitbucket netrc auto-generation (and mark gitlab args as deprecated)

# Version 2.0 of the image

* remove ONBUILD gitlab args in favour of more generic args
