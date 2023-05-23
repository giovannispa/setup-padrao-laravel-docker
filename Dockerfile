# Utilizando a versão do php recomendada pelo Laravel
FROM php:8.1-fpm

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
    unzip

# Limpando o cache dos arquivos baixados do npm
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilitando as extensoes do php que o laravel pede
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Transformando o composer em variavel de ambiente no container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criando um usuário administrador para ter acesso ao git, composer e artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Instalando o redis e habilitando a extensao dele no php
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Setando o diretório de desenvolvilmento do nginx
WORKDIR /var/www

# Definindo o usuario que vai acessar o container
USER $user