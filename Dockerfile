# Usa imagen de PHP con Apache
FROM php:8.2-apache

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    zip unzip curl git libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql zip

# Habilita Apache rewrite
RUN a2enmod rewrite

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia los archivos del proyecto
COPY . /var/www/html/

# Configura el directorio raíz de Laravel
WORKDIR /var/www/html

# Establece permisos (ajustado para producción)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Variables de entorno opcionales
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Cambia DocumentRoot en Apache
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Expone el puerto 80
EXPOSE 80
