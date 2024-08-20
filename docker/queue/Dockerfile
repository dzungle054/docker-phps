#=========================================
# Multi stage build - base image
#=========================================
FROM php:8.1-alpine AS base

# Override default shell
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

# Work dir difinition
ENV WORKDIR=/home
WORKDIR $WORKDIR

# Composer environment
ENV COMPOSER_HOME=/composer
# timezone environment
ENV TZ=Asia/Tokyo
# locale
ENV LANG=ja_JP.UTF-8

# Set Timezone
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata

# For generating QR image as png
RUN apk add --no-cache imagemagick \
    && apk add --no-cache --virtual .phpize-deps imagemagick-dev build-base autoconf libpng-dev libjpeg-turbo-dev libxml2-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del .phpize-deps

# for mysqldump back db
RUN apk add --no-cache mysql-client

# For url hashing
RUN apk add gmp-dev
RUN docker-php-ext-install gmp mysqli
RUN docker-php-ext-install sockets
# Install packages
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
    py3-setuptools \
    supervisor \
    curl-dev \
    freetype-dev \
    libzip-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    zlib-dev \
    pcre-dev \
    g++ \
    make \
    autoconf \
    openssl \
    bash \
    vim \
    git \
    msmtp \
    && docker-php-ext-install \
    curl \
    dom \
    pdo \
    pdo_mysql \
    simplexml \
    zip \
    opcache \
    && docker-php-ext-configure gd \
    --with-jpeg=/usr/include/ \
    --with-freetype=/usr/include/  \
    && docker-php-ext-install gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/cache/apk/*

COPY ./docker/queue/php.development.ini /usr/local/etc/php/php.ini

#=============================================
# Multi stage build - local
#=============================================
FROM base AS development

# config supervisord
COPY ./docker/queue/supervisord.d/queue.conf /etc/supervisord.d/queue.conf
COPY ./docker/queue/supervisord.d/schedule.conf /etc/supervisord.d/schedule.conf
COPY ./docker/queue/supervisord.conf /etc/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
