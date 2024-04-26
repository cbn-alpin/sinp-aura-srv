FROM matomo:5.0.3-fpm
# See : https://github.com/matomo-org/docker/blob/master/fpm/Dockerfile
# Also see : https://github.com/crazy-max/docker-matomo

ARG MSMTP_OVH_PWD

# Install utils and sendmail
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim sudo cron libfcgi-bin \
		msmtp msmtp-mta bsd-mailx mailutils \
	&& rm -rf /var/lib/apt/lists/*

# Override php.ini properties for Matomo
COPY matomo.ini /usr/local/etc/php/conf.d/matomo.ini

# Set new entry point from :
COPY docker-entrypoint.sh /entrypoint.sh

# Add healthcheck Bash script
COPY php-fpm-healthcheck.sh /usr/local/bin/php-fpm-healthcheck

# Setup PHP-FPM config
RUN echo 'ping.path = /ping' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.status_path = /status' >> /usr/local/etc/php-fpm.d/zz-docker.conf

# Set Cron for Matomo archive
# DON'T USE dot or dash in cron.d script file name howerer the script will never execute.
# DON'T USE crontab because it's distinc of use of cron.d directory (service cron) !
COPY matomo_archive.cron /etc/cron.d/matomo_archive
RUN  chmod 0644 /etc/cron.d/matomo_archive \
	&& chown root: /etc/cron.d/matomo_archive \
	&& chmod u+s /usr/sbin/cron \
	&& mkdir -p /var/www/html/tmp/logs/ \
	&& touch /var/log/cron.log \
	&& touch /var/www/html/tmp/logs/matomo-archive.log \
	&& touch /var/www/html/tmp/logs/matomo-archive-errors.log \
	&& chown www-data: /var/www/html/tmp/logs/matomo-archive*

# WARNING : to avoid empty matomo-archive.log. Matomo console:archive needs this file to work !
RUN printenv > /etc/environment

# Create Msmtp config file
COPY msmtprc.tpl.conf /etc/msmtprc
RUN sed -i "s/\$MSMTP_OVH_PWD/${MSMTP_OVH_PWD}/g" /etc/msmtprc \
	&& chmod 600 /etc/msmtprc \
	&& chown www-data:www-data /etc/msmtprc

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

VOLUME /var/www/html
# Use new entry point wrapper with Cron start
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
