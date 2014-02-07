FROM ubuntu:quantal
MAINTAINER dominik.burgdoerfer@gmail.com

RUN echo "deb http://archive.ubuntu.com/ubuntu quantal main universe" >/etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q openssh-server \
    nginx \
    mysql-server \
    php5-fpm php5-mysql php5-gd php5-ldap php5-imap \
    supervisor \
    pwgen
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx-limesurvey.conf /etc/nginx/sites-available/default
RUN sed 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN mkdir -p /var/www
RUN wget -nv 'http://www.limesurvey.org/en/stable-release/finish/25-latest-stable-release/1053-limesurvey205plus-build140204-tar-gz' -O /var/www/limesurvey.zip
RUN cd /var/www && tar -xvzf limesurvey.zip && rm limesurvey.zip && chown www-data:www-data -R limesurvey
ADD start.sh /start
ENV TZ Europe/Berlin
EXPOSE 22 80
CMD ["/bin/bash", "/start"]
