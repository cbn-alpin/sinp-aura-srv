FROM justb4/awstats:7.6-2
# https://hub.docker.com/r/justb4/awstats

LABEL	maintainer="Jean-Pascal Milcent <jp.milcent@cbn-alpin.fr>" \
	source="https://hub.docker.com/r/justb4/awstats/dockerfile"

# Install utils
RUN apt-get update --allow-releaseinfo-change \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim \
	&& rm -rf /var/lib/apt/lists/*

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
