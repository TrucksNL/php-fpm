FROM php

COPY --link --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update --no-cache \
    && apk add --no-cache \
    fcgi \
    git \
    openssh

RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

RUN echo 'pm.status_path = /status' >> /usr/local/etc/php-fpm.d/zz-docker.conf

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    grpc \
    intl \
    mongodb-stable \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    redis-stable \
    sysvsem \
    zip

RUN mkdir -p /root/.ssh/ \
    && ssh-keyscan bitbucket.org > /root/.ssh/known_hosts
