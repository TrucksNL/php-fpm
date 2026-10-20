# TrucksNL PHP-FPM container image

[![Docker Image CI](https://github.com/TrucksNL/php-fpm/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/TrucksNL/php-fpm/actions/workflows/docker-image.yml)

## Image variants

Every PHP/Alpine combination is published in two variants. Both run as `www-data` by default.

| Tag | Contents | Use for |
|-----|----------|---------|
| `8.4-alpine3.24` | PHP-FPM, extensions, healthcheck | Final runtime images |
| `8.4-alpine3.24-build` | Runtime plus `git`, `openssh`, Composer and pinned Bitbucket host keys | Build stages, e.g. `composer install` with VCS dependencies |

The same suffix applies to the `-v<run>` and `-alpine-latest` tags, e.g. `8.4-alpine-latest-build`.

Example multi-stage build:

```dockerfile
FROM ghcr.io/trucksnl/php-fpm:8.4-alpine-latest-build AS vendor
COPY composer.* ./
RUN --mount=type=ssh composer install --no-dev

FROM ghcr.io/trucksnl/php-fpm:8.4-alpine-latest
COPY --from=vendor --chown=www-data:www-data /var/www/html/vendor ./vendor
COPY . .
```

The images run as `www-data`. Switch to root where needed (e.g. `install-php-extensions`), then switch back:

```dockerfile
USER root
RUN install-php-extensions xsl
USER www-data
```
