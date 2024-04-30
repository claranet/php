FROM ${IMAGE}

ENV DOCUMENT_ROOT="${WORKDIR}" \
    COMPRESS_FILE_PATHS="js"

ENV MATOMO_VERSION="5.0.3" \
    MYSQL_HOST="mysql" \
    MYSQL_USER="matomouser"

COPY docker ${WORKDIR}/docker

RUN /entrypoint.sh build deps
RUN /entrypoint.sh build matomo
