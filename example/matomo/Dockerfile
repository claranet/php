FROM local/claranet/php:1.0.3-php7.2.5

ENV DOCUMENT_ROOT="${WORKDIR}" \
    COMPRESS_FILE_PATHS="js" \
    ENABLE_BOWER="true"

ENV MATOMO_VERSION="3.4.0"

COPY docker ${WORKDIR}/docker

RUN /entrypoint.sh build deps
RUN /entrypoint.sh build matomo
