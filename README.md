# 💻 Setup completo de desenvolvilmento em docker para Laravel.
Este repositório foi criado para ser usado em um setup de ambiente completo de desenvolvimento em Laravel com docker. Funciona para máquina local e produção.

### Passo a passo:

Clone o repositório:
```sh
git clone https://github.com/giovannispa/setup-padrao-laravel-docker.git
```

Clone o repositório original do Laravel:
```sh
git clone https://github.com/laravel/laravel.git meu-projeto
```

Copie todos os arquivos do repositório para o repositório do Laravel:
```sh
cp -rf setup-padrao-laravel-docker/* meu-projeto/
```
```sh
cd meu-projeto/
```

Remova o repositório padrão do git da pasta do seu projeto:
```sh
rm -rf .git
```

Crie o Arquivo .env:
```sh
cp .env.example .env
```

Atualize as variáveis de ambiente do arquivo .env:
```dosini
DB_CONNECTION=mysql
DB_HOST=mysql #nome do container do seu banco de dados criado no docker-compose.yml.(O meu por padrão deixei mysql)
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=root

ARGS_USER=teste #nome do super usuário criado dentro do container customizado app no docker-compose.yml
ARGS_UID=1000 #Uid padrão dos argumentos enviados para o container customizado app

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=redis #nome do container do seu sistema de cache no docker-compose.yml.(O meu por padrão deixei redis)
REDIS_PASSWORD=null
REDIS_PORT=6379
```
# Opcionais

### Adicionando phpmyadmin para ambiente dev:

No arquivo docker-compose.yml:
```dosini
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - 8080:80
    environment:
      PMA_HOST: mysql #nome do container do banco de dados
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
    depends_on:
        - mysql #nome do container do banco de dados
    networks:
      - laravel
```
# Subindo o projeto

Suba os containers do projeto:
```sh
docker-compose up -d
```

Acessar o container:
```sh
docker-compose exec app bash
```

Instalar as dependências do projeto:
```sh
composer install
```

Gerar a key do projeto Laravel:
```sh
php artisan key:generate
```
