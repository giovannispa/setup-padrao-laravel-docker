# Utilizando a versão do php recomendada pelo Laravel
FROM php:8.2-fpm

# Recuperando as variaveis do docker-compose.yml
ARG user
ARG uid

# Instalando só o necessário para que o container funcione perfeitamente.
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    vim \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Transformando o composer em variavel de ambiente no container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalando e habilitando o Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configurações do Xdebug
COPY docker/xdebug/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Criando um usuário administrador para ter acesso ao git, composer e artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Habilitando e configurando Opcache
RUN docker-php-ext-install opcache

# Instalando o redis e habilitando a extensao dele no php
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Setando o diretório de desenvolvilmento do nginx
WORKDIR /var/www

# Definindo o usuario que vai acessar o container
USER $user