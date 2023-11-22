FROM alpine:3.14
LABEL Maintainer="Sendya <yladmxa@gmail.com>"
LABEL Description="Nginx & PHP based on Alpine Linux."

WORKDIR /var/www/html

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk add --no-cache \
    nginx \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-intl \
    php7-mbstring \
    php7-mysqli \
    php7-pdo \
    php7-pdo_mysql \
    php7-opcache \
    php7-openssl \
    php7-phar \
    php7-session \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter

COPY docker-entrypoint.sh /usr/local/bin/

# Configure nginx - http
COPY etc/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY etc/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
ENV PHP_INI_DIR /etc/php7
COPY etc/fpm-pool.conf ${PHP_INI_DIR}/php-fpm.d/www.conf
COPY etc/php.ini ${PHP_INI_DIR}/conf.d/custom.ini

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx \
  && ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm

# Switch to use a non-root user from here on
USER nobody

# Add application
COPY --chown=nobody index.php /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 8080

# Let start nginx & php-fpm
ENTRYPOINT ["docker-entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
