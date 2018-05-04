#!/bin/bash

set -x
set -eo pipefail

WORKDIR=${WORKDIR:-`realpath $0 | xargs dirname | xargs dirname`}
export DOCKER_IMAGE_FROM_TAG=${DOCKER_IMAGE_FROM_TAG:-"7.2.5-fpm-stretch"}
DOCKER_IMAGE_FROM_TAG_VERSION_NUMBER=`echo "$DOCKER_IMAGE_FROM_TAG" | cut -d- -f1`
PROJECT_VERSION=${PROJECT_VERSION:-1.0.0}

IMAGE_NAME=${IMAGE_NAME:-local/claranet/php}
IMAGE_TAG="${IMAGE_TAG:-$PROJECT_VERSION}-php${DOCKER_IMAGE_FROM_TAG_VERSION_NUMBER}"
IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

test_image() {
    docker run --rm -t ${1} test
}

build_image() {
    envsubst '$DOCKER_IMAGE_FROM_TAG' < Dockerfile | docker build -t $* -f - ${WORKDIR}
}

dockerhub_login() {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
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

