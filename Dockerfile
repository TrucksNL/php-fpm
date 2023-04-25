FROM php:8.2-fpm-alpine3.17

COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache \
    git

RUN install-php-extensions \
    gd \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    redis-stable \
    zip
