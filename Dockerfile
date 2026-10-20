ARG PHP_VERSION=8.4
ARG ALPINE_VERSION=3.24

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} AS runtime

LABEL org.opencontainers.image.source="https://github.com/TrucksNL/php-fpm" \
      org.opencontainers.image.description="TrucksNL PHP-FPM base image"

COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache \
    fcgi \
    && wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck \
    && echo 'pm.status_path = /status' >> /usr/local/etc/php-fpm.d/zz-docker.conf

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    mongodb-stable \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    redis-stable \
    sysvsem \
    zip

# Applications that need root (e.g. install-php-extensions) can switch with `USER root`.
USER www-data

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD php-fpm-healthcheck

# Same as runtime, plus git and ssh for fetching private dependencies (e.g. composer VCS installs).
# CI overrides the runtime stage with the published runtime image (--build-context runtime=docker-image://...),
# so only the layers below are built.
FROM runtime AS build

USER root

RUN apk add --no-cache \
    git \
    openssh

# Bitbucket host keys, from https://bitbucket.org/site/ssh (verify against Atlassian's published fingerprints).
# System-wide, so ssh works for any user.
COPY --chmod=644 known_hosts /etc/ssh/ssh_known_hosts

USER www-data
