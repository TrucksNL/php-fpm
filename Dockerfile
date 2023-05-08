ARG ALPINE_VERSION='3.17'
ARG PHP_VERSION='8.2'

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache \
    git

RUN install-php-extensions \
    bcmath \
    gd \
    intl \
    mongodb-stable \
    mysqli \
    opcache \
    pdo_mysql \
    redis-stable \
    sysvsem \
    zip
