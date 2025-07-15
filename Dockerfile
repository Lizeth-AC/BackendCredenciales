FROM php:8.2-fpm

# Instala dependencias del sistema
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
    && docker-php-ext-install pdo pdo_mysql zip

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia los archivos del proyecto
COPY . .

# Ajusta permisos (si usas Laravel)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Instala dependencias de PHP
RUN composer install --no-dev --optimize-autoloader -vvv

# Expone el puerto que usarás en Render
EXPOSE 8000

# Comando para iniciar el servidor
CMD php artisan serve --host=0.0.0.0 --port=8000

# Establecer permisos
RUN chown -R www-data:www-data storage bootstrap/cache

# Establecer DocumentRoot en Apache para usar /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Cambiar configuración de Apache para apuntar a /public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Exponer puerto 80
EXPOSE 80
