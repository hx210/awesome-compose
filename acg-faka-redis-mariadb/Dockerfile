FROM webdevops/php-nginx:8.0-alpine
COPY . /app
WORKDIR /app

RUN [ "sh", "-c", "composer update" ]
RUN set -xe \
    && composer install --ignore-platform-reqs \
    && cp -f conf/10-location-root.conf /opt/docker/etc/nginx/vhost.common.d/10-location-root.conf \
    && chown -R application:application /app \
    && chmod -R 0755 /app \
    && rm -rf /root/.composer/cache/ /tmp/*