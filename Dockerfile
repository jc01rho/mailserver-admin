FROM jeboehm/php-nginx-base:7.2
LABEL maintainer="jeff@ressourcenkonflikt.de"

COPY nginx.conf /etc/nginx/sites-enabled/10-docker.conf
COPY . /var/www/html/

ENV APP_ENV=prod \
    TRUSTED_PROXIES=172.16.0.0/12 \
    ADMIN_USERS="admin@example.com"

RUN composer install --no-dev --prefer-dist -o --apcu-autoloader && \
    bin/console cache:clear --no-warmup --env=prod && \
    bin/console cache:warmup --env=prod && \
    bin/console assets:install public --env=prod && \
    rm -f nginx.conf