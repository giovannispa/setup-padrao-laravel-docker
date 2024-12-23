# Utilizando a versão do PHP recomendada pelo Laravel
FROM php:8.2-fpm

# Recuperando as variáveis do docker-compose.yml
ARG user
ARG uid

# Atualizando pacotes e instalando dependências
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    vim \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Transformando o Composer em variável de ambiente no container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurações do Xdebug
COPY docker/xdebug/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Criando um usuário administrador para acessar o git, Composer e Artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Definindo o diretório de desenvolvimento do Nginx
WORKDIR /var/www

# Definindo o usuário que acessará o container
USER $user
