FROM debian:bullseye

RUN	apt update && apt install -y \
	php-fpm \
	php-mysql \
	wget \
	curl \
	default-mysql-client

# WP-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

RUN	mkdir -p /run/php
RUN	mkdir -p /var/www/html

# Download WordPress
#RUN	wget https://wordpress.org/latest.tar.gz \
#	&& tar -xvf latest.tar.gz \
#	&& mkdir -p /var/www/html \
#	&& mv wordpress/* /var/www/html \
#	&& rm -rf wordpress latest.tar.gz

# Permissions
#RUN chown -R www-data:www-data /var/www/html

#PHP-FPM config
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy script init
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

CMD ["bash", "/init.sh"]
