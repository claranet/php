FROM claranet/php:latest

ENV DOCUMENT_ROOT="${WORKDIR}" \
    COMPRESS_FILE_PATHS="js"

ENV MATOMO_VERSION="3.5.0"

COPY docker ${WORKDIR}/docker

RUN /entrypoint.sh build deps
RUN /entrypoint.sh build matomo
