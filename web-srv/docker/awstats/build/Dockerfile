FROM debian:10.2-slim
# https://hub.docker.com/_/debian

LABEL	maintainer="Jean-Pascal Milcent <jp.milcent@cbn-alpin.fr>" \
		source="https://hub.docker.com/r/justb4/awstats/dockerfile"

ARG	GEOIP_PACKAGES="libgeo-ipfree-perl libnet-ip-perl"


# Install utils and sendmail
RUN	apt-get update \
	&& apt-get install -yy --no-install-recommends \
		awstats gettext-base ${GEOIP_PACKAGES} supervisor cron \
		less vim \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /var/www && mv /usr/share/awstats/icon /var/www/icons && chown -R www-data:www-data /var/www \
	&& apt-get clean && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Configurations, some are templates to be substituted with env vars
ADD confs/awstats_env.conf confs/awstats_env.cron /etc/awstats/
ADD confs/awstats_httpd.conf /usr/local/apache2/conf/
ADD confs/supervisord.conf /etc/
ADD scripts/*.sh  /usr/local/bin/

# Default env vars
ENV \
	AWSTATS_CONF_DIR="/etc/awstats" \
	AWSTATS_SITES_DIR="/etc/awstats/sites" \
	AWSTATS_CRON_SCHEDULE="*/15 * * * *" \
	AWSTATS_PATH_PREFIX="" \
	AWSTATS_CONF_LOGFILE="/var/local/log/access.log" \
	AWSTATS_CONF_LOGFORMAT="%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot" \
	AWSTATS_CONF_SITEDOMAIN="mydomain.com" \
	AWSTATS_CONF_HOSTALIASES="localhost 127.0.0.1 REGEX[^.*$]" \
	AWSTATS_CONF_DEBUGMESSAGES="0" \
	AWSTATS_CONF_DNSLOOKUP="1"


# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
