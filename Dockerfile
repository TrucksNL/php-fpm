ARG ALPINE_VERSION='3.18'
ARG PHP_VERSION='8.2'

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache \
    fcgi \
    git

RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

RUN echo 'pm.status_path = /status' >> /usr/local/etc/php-fpm.d/zz-docker.conf

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
