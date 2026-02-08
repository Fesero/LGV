FROM php:8.4-cli-alpine

ARG UID=1000
ARG GID=1000

RUN apk add --no-cache \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libpq-dev \
    oniguruma-dev \
    postgresql-client

RUN docker-php-ext-install pdo_pgsql mbstring zip exif pcntl bcmath gd

RUN apk add --no-cache pcre-dev $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN addgroup -g $GID laravel && \
    adduser -u $UID -G laravel -s /bin/sh -D laravel

WORKDIR /var/www/html

COPY --chown=laravel:laravel . .

USER laravel