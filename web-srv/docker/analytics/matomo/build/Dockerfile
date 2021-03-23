FROM matomo:4.2.1-fpm
# See : https://github.com/matomo-org/docker/blob/master/fpm/Dockerfile

ARG MSMTP_OVH_PWD

# Install utils and sendmail
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim sudo cron \
		msmtp msmtp-mta bsd-mailx mailutils \
	&& rm -rf /var/lib/apt/lists/*

# Override php.ini properties for Matomo
COPY matomo.ini /usr/local/etc/php/conf.d/matomo.ini

# Set new entry point from :
COPY docker-entrypoint.sh /entrypoint.sh

# Set Cron for Matomo archive
# DON'T USE dot or dash in cron.d script file name howerer the script will never execute.
COPY matomo-archive.cron /etc/cron.d/matomo_archive
RUN  chmod 0644 /etc/cron.d/matomo-archive \
	&& chown root: /etc/cron.d/matomo_archive \
	&& crontab /etc/cron.d/matomo_archive \
	&& touch /var/www/html/tmp/logs/matomo-archive.log \
	&& touch /var/www/html/tmp/logs/matomo-archive-errors.log \
	&& chown www-data: /var/www/html/tmp/logs/matomo-archive*

# Create Msmtp config file
COPY msmtprc.conf /etc/msmtprc
RUN sed -i "s/\$MSMTP_OVH_PWD/${MSMTP_OVH_PWD}/g" /etc/msmtprc && \
	chmod 600 /etc/msmtprc && \
	chown www-data:www-data /etc/msmtprc

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
