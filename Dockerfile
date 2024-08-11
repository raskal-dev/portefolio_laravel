FROM php:8.3.0 as php
WORKDIR /var/www

RUN apt-get update -y && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev 


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . .

RUN docker-php-ext-install gettext intl pdo_mysql gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Exposer le port utilisé par le serveur Laravel
ENV PORT=8000

ENTRYPOINT ["docker/entrypoint.sh"]

