#!/bin/bash
set -e

cd /var/www; php artisan config:cache
# apaga symlink antigo
rm public/storage
# cria um novo com o path do projeto no docker container
php artisan storage:link
env >> /var/www/.env

php-fpm7.2 -D
nginx -g "daemon off;"

