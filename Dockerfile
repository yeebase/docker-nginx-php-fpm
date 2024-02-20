FROM t3nde/debian-base:bullseye

ENV PHP_VERSION 8.1

RUN set -x && \
  clean-install \
    apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    ca-certificates && \
  curl -sL https://packages.sury.org/php/apt.gpg | apt-key add - && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
  dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
  sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
  curl -sL https://nginx.org/keys/nginx_signing.key | apt-key add - && \
  echo "deb https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" > /etc/apt/sources.list.d/nginx.list && \
  echo "deb-src https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" >> /etc/apt/sources.list.d/nginx.list && \
  echo 'deb https://packages.tideways.com/apt-packages-main any-version main' >> /etc/apt/sources.list.d/tideways.list && \
  curl -sL https://packages.tideways.com/key.gpg | apt-key add - && \
  clean-install \
  php${PHP_VERSION}-common \
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-fpm \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-gd \
  php${PHP_VERSION}-mbstring \
  php${PHP_VERSION}-mysql \
  php${PHP_VERSION}-opcache \
  php${PHP_VERSION}-readline \
  php${PHP_VERSION}-soap \
  php${PHP_VERSION}-tidy \
  php${PHP_VERSION}-xml \
  php${PHP_VERSION}-xmlrpc \
  php${PHP_VERSION}-bcmath \
  php${PHP_VERSION}-zip \
  php${PHP_VERSION}-mongodb \
  php${PHP_VERSION}-redis && \
  clean-install \
  tideways-php \
  tideways-cli \
  nginx-core && \
  mkdir -p /run/php /var/www /var/log/nginx/ && \
  ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm && \
  rm -r /opt && \
  mv /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/10-www.conf
  # rm /etc/nginx/conf.d/default.conf

COPY conf/nginx /etc/nginx
COPY conf/php /etc/php/${PHP_VERSION}
COPY bin/ /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx-php-fpm

EXPOSE 80 9100

CMD ["nginx-php-fpm"]
