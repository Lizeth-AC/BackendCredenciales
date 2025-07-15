FROM php:8.2-apache

# Instalar extensiones necesarias para Laravel
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql zip

# Activar mod_rewrite para Laravel
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar archivos del proyecto al contenedor
COPY . /var/www/html/

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Establecer permisos
RUN chown -R www-data:www-data storage bootstrap/cache

# Establecer DocumentRoot en Apache para usar /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Cambiar configuración de Apache para apuntar a /public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Exponer puerto 80
EXPOSE 80
