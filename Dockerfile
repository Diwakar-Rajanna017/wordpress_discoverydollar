FROM php:7.4-apache

#seting arg for Wordpress version and url
ARG WORDPRESS_VERSION=5.7
ARG WORDPRESS_URL=https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz

# packages to install
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    && docker-php-ext-install zip 

ENV APACHE_DOCUMENT_ROOT /var/www/html
# Set the working directory to /var/www/html
WORKDIR $APACHE_DOCUMENT_ROOT

# Enable mod_rewrite for WordPress permalinks
RUN a2enmod rewrite

# Download and install WordPress
RUN curl -o wordpress.tar.gz -SL $WORDPRESS_URL && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz && \
    chown -R www-data:www-data ${APACHE_DOCUMENT_ROOT}

# Copy a custom Apache config to enable .htaccess and set AllowOverride
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80

# Define the ENTRYPOINT and CMD
ENTRYPOINT ["apache2-foreground"]
CMD ["-D", "FOREGROUND"]