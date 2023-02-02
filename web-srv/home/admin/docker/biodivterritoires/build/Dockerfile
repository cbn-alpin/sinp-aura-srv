FROM lpoaura/geonature-biodivterritoires:orb_aura
# https://hub.docker.com/r/lpoaura/geonature-biodivterritoires

LABEL maintainer="Jean-Pascal Milcent <jp.milcent@cbn-alpin.fr>"

ARG TZ
ARG APP_NAME
ARG APP_GUNICORN_WORKERS
ARG APP_GUNICORN_TIMEOUT
ARG APP_GUNICORN_HOST
ARG APP_GUNICORN_PORT

ENV TZ="${TZ}"
# Gunicorn default parameters
ENV app_name=${APP_NAME}
ENV gun_num_workers=${APP_GUNICORN_WORKERS}
ENV gun_timeout=${APP_GUNICORN_TIMEOUT}
ENV gun_host=${APP_GUNICORN_HOST}
ENV gun_port=${APP_GUNICORN_PORT}


# Install utils
RUN apt-get update --allow-releaseinfo-change \
	&& apt-get install -y --no-install-recommends \
		apt-utils locales less vim curl telnet iputils-ping \
	&& rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i 's/# \(fr_FR\.UTF-8 .*\)/\1/' /etc/locale.gen \
	&& touch /usr/share/locale/locale.alias \
	&& locale-gen

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

# Manage docker-entrypoint.sh
COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

CMD [ "docker-entrypoint.sh" ]
