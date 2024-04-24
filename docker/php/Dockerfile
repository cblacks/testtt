# Ubuntu 22.04
FROM ubuntu:jammy AS cli

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php

# Install Ondrej repos for Ubuntu jammy, PHP, composer, and selected extensions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg \
        ca-certificates \
        curl \
        unzip \
        php8.2-apcu \
        php8.2-cli \
        php8.2-curl \
        php8.2-mbstring \
        php8.2-opcache \
        php8.2-readline \
        php8.2-xml \
        php8.2-zip \
        git \
        php8.2-mysql \
        php8.2-gd \
        openssh-client \
        php8.2-redis \
        wget \
        openssl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

CMD ["php", "-a"]

# Separate build stage for FPM
FROM cli AS fpm

# Install FPM
RUN apt-get update \
    && apt-get install -y --no-install-recommends php8.2-fpm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

STOPSIGNAL SIGQUIT

# PHP-FPM packages need a nudge to make them docker-friendly
COPY overrides.conf /etc/php/8.2/fpm/pool.d/z-overrides.conf

CMD ["/usr/sbin/php-fpm8.", "-O"]

# Open up fcgi port
EXPOSE 9000

WORKDIR "/project"

ADD launch.sh /root/launch.sh
RUN chmod +x /root/launch.sh
ENTRYPOINT ["/root/launch.sh"]
