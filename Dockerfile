# Usa PHP 8.2 con FPM
FROM php:8.2-fpm

# Instala dependencias del sistema y extensiones requeridas
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-install pdo pdo_mysql zip bcmath

# Copia Composer desde la imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia los archivos del proyecto
COPY . .

# Ajusta permisos
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Instala dependencias de PHP
RUN composer install --no-dev --optimize-autoloader -vvv

# Expone el puerto 8000 (usado por php artisan serve)
EXPOSE 8000

# Comando por defecto para iniciar Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader -vvv

