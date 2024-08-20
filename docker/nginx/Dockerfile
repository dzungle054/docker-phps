#=========================================
# Multi stage build - base image
#=========================================
FROM nginx:1.21-alpine AS base

# Override default shell
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata

#=========================================
# Multi stage build - local stage
#=========================================
FROM base AS local

# Install minimum required package
RUN apk update && \
    apk add --update --no-cache --virtual=.build-dependencies g++

WORKDIR /home

# Place config template file into the image
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
# Replace conf file with env variable PHP_HOST
# Start nginx foreground
CMD /bin/sh -c 'sed "s/\${PHP_HOST}/${PHP_HOST}/" /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"'

EXPOSE 80
