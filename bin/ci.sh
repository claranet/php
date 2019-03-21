#!/bin/sh

# Simulate CI stages and handle all steps required to build, test and publish a new version of this image
WORKDIR=$(realpath $0 | xargs dirname | xargs dirname)

export VERSION=$(cat $WORKDIR/VERSION)
export IMAGE_NAME="claranet/php"
FROM_IMAGE_TAGS="7.1.27-fpm-jessie 7.2.16-fpm-stretch"
LATEST_IMAGE="7.2.16-fpm-stretch"

# based on $TRAVIS_BRANCH
# we decide to...
#  * release on == (e.g.) 1.1.1 tags
#  * build/test only if this is a PR
#  * build/test/publish with master tag if this is a push to master
run_ci() {
    # Pull requests
    if [ ! -z "$TRAVIS_PULL_REQUEST" ] && [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
        printf "\nPull Request\n"
        stage_pr
        return $?
    fi

    # Push to MASTER
    if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
        printf "\nPush to master\n"
        stage_publish
        return $?
    fi

    # Tags
    if echo "$TRAVIS_TAG" | egrep '^([0-9]+\.[0-9]+\.[0-9]+)$' &> /dev/null; then
        printf "\nTag Release\n"
        stage_release
        return $?
    fi
}

prepare_variables() {
    local from_tag_string="$1"
    export PHP_VERSION=`echo "$from_tag_string" | cut -d- -f1`
    export IMAGE="$IMAGE_NAME:php$PHP_VERSION"
    export FROM_IMAGE="php:$from_tag_string"
}

run_per_php_flavour() {
    for PHP_FLAVOUR in $FROM_IMAGE_TAGS; do
        prepare_variables $PHP_FLAVOUR
        $*
    done
}

# STAGES
stage_pr() {
    run_per_php_flavour build_image
    run_per_php_flavour test_image
}
stage_publish() {
    stage_pr
    dockerhub_login
    run_per_php_flavour publish_image $TRAVIS_BRANCH
}
stage_release() {
    stage_publish
    run_per_php_flavour release_image
}


# STEPS
build_image() {
    printf "Build image $VERSION flavor $PHP_VERSION\n"
    $WORKDIR/bin/image.sh build
}
test_image() {
    printf "Test image $VERSION flavour $PHP_VERSION\n"
    $WORKDIR/bin/image.sh test
}
publish_image() {
    local tag="$1-php$PHP_VERSION"
    printf "Publish image $VERSION tag $tag\n"
    docker tag $IMAGE $IMAGE_NAME:$tag
    docker push $IMAGE_NAME:$tag
}
release_image() {
    printf "Release image $VERSION php $PHP_VERSION\n"

    local major=`echo "$VERSION" | cut -d. -f1`
    local minor=`echo "$VERSION" | cut -d. -f2`
    TAG_LIST="$major-php$PHP_VERSION $major.$minor-php$PHP_VERSION $VERSION-php$PHP_VERSION"

    if [ "$LATEST_IMAGE" = "$PHP_FLAVOUR" ]; then
        TAG_LIST="$TAG_LIST latest"
    fi

    for tag in $TAG_LIST; do
        docker tag $IMAGE $IMAGE_NAME:$tag
        docker push $IMAGE_NAME:$tag
    done
}

dockerhub_login() {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
}

case "$1" in
    run)
        run_ci
    ;;
    *)
        printf "\nUsage: $0 run"
    ;;
esac
