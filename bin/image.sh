#!/bin/bash

set -x
set -eo pipefail
WORKDIR=$(realpath $0 | xargs dirname | xargs dirname)

export FROM_IMAGE=${FROM_IMAGE:-php:7.2.16-fpm-stretch}
PHP_VERSION=${PHP_VERSION:-7.2.16}
VERSION=${VERSION:-`cat $WORKDIR/VERSION`}
IMAGE_NAME=${IMAGE_NAME:-local/claranet/php}
IMAGE_TAG=${IMAGE_TAG:-$VERSION-php$PHP_VERSION}
IMAGE=${IMAGE:-"$IMAGE_NAME:$IMAGE_TAG"}

test_image() {
    docker run --rm -t ${1} test
    docker build -t local/matomo:$IMAGE_TAG -f example/matomo/Dockerfile example/matomo/
}

build_image() {
    envsubst '$FROM_IMAGE' < Dockerfile | docker build -t $* -f - ${WORKDIR}
}



dockerhub_push() {
    if [ -z $(docker image list -q ${IMAGE}) ]; then
        build_image "${IMAGE}-nobase" --build-arg "RUN_BUILD_BASE=false"
        build_image ${IMAGE}
        test_image ${IMAGE}
    fi
    
    dockerhub_login

    # push version tag
    docker push ${IMAGE}
    docker push ${IMAGE}-nobase
}

case "$1" in
    build)
        build_image ${IMAGE}
        ;;
    test)
        test_image ${IMAGE}
        ;;
    publish)
        dockerhub_push

        # push latest tag
        docker tag ${IMAGE} ${IMAGE_NAME}:latest
        docker push ${IMAGE_NAME}:latest

        docker tag ${IMAGE}-nobase ${IMAGE_NAME}:latest-nobase
        docker push ${IMAGE_NAME}:latest-nobase
        ;;
    *)
        echo "\nUsage $0 <build|test|publish>\n"
esac

