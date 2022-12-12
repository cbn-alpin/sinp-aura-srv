FROM lpoaura/geonature-biodivterritoires:orb_aura
# https://hub.docker.com/r/lpoaura/geonature-biodivterritoires

LABEL	maintainer="Jean-Pascal Milcent <jp.milcent@cbn-alpin.fr>"

# Install utils
RUN apt-get update --allow-releaseinfo-change \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim telnet iputils-ping \
	&& rm -rf /var/lib/apt/lists/*

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

CMD [ "docker-entrypoint.sh" ]
