FROM php:7.1-fpm-alpine

# Override default shell
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

# Work dir difinition
ENV WORKDIR=/wordpress
WORKDIR $WORKDIR

# Set Timezone
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata

# Install packages
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
    curl-dev \
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
    nginx  \
    supervisor \
    && docker-php-ext-install \
    curl \
    dom \
    pdo \
    pdo_mysql \
    simplexml \
    zip \
    opcache \
    mysqli \
    && docker-php-ext-configure gd \
    --with-jpeg=/usr/include/ \
    --with-freetype=/usr/include/  \
    && docker-php-ext-install gd \
    && rm -rf /var/cache/apk/*

COPY ./docker/wordpress/supervisord.conf /etc/supervisord.conf
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./docker/wordpress/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/wordpress/nginx/http.d/default.conf /etc/nginx/http.d/default.conf
COPY ./docker/php/php.production.ini /usr/local/etc/php/php.ini

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
RUN mkdir -p /run/nginx
# Place application into image
COPY ./wordpress $WORKDIR

ARG UID=1001
ARG UNAME=www
ARG GID=1001
ARG GNAME=www

RUN addgroup ${GNAME} -g ${GID} \
    # Add linux user
    && adduser -D -G ${GNAME} -u ${UID} ${UNAME} \
    && chown -R ${UNAME}:nginx /var/lib/nginx

EXPOSE 80
