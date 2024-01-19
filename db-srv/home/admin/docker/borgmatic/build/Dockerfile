FROM debian:12.2-slim
# Builder to avoid to embed develop files

LABEL mainainer="Jean-Pascal MILCENT"
LABEL source="https://github.com/b3vis/docker-borgmatic"

ARG MAILTO
ARG PGSQL_MAJOR_VERSION
# Borg releases: https://www.borgbackup.org/releases/
ARG BORG_VERSION=1.2.7
# Borgmatic releases: see https://github.com/witten/borgmatic
ARG BORGMATIC_VERSION=1.8.5
# PyFuse releases: https://pypi.org/project/pyfuse3/#history
ARG PYFUSE_VERSION=3.3.0

ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
ENV LC_ALL fr_FR.UTF-8

# Install packages
RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive \
                apt-get install -y --quiet --no-install-recommends \
                        apt-utils locales less curl wget vim sudo cron iputils-ping gnupg lsb-release bash-completion \
                        msmtp msmtp-mta bsd-mailx mailutils \
                        tzdata \
                        sshfs \
                        python3 python3-dev python3-pip python3-virtualenv \
                        libacl1-dev libacl1 \
                        libssl-dev \
                        lz4 liblz4-dev libzstd-dev libxxhash-dev \
                        build-essential \
                        pkg-config python3-pkgconfig \
                        openssl \
                        ca-certificates \
                        libfuse3-dev fuse3 \
        # Add postresql deb package repo
        && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
        && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
        && apt-get update \
                && DEBIAN_FRONTEND=noninteractive \
                        apt-get install -y --quiet --no-install-recommends "postgresql-client-${PGSQL_MAJOR_VERSION}" \
        && rm /usr/lib/python3.11/EXTERNALLY-MANAGED \
        && python3 -m pip install --upgrade pip \
        && python3 -m pip install -U pip setuptools wheel \
        && python3 -m pip install --upgrade borgbackup==${BORG_VERSION} \
        && python3 -m pip install --upgrade borgmatic==${BORGMATIC_VERSION} \
        && python3 -m pip install --upgrade pyfuse3==${PYFUSE_VERSION} \
        && python3 -m pip install --upgrade ntfy[pid,emoji,telegram,instapush,slack,rocketchat] \
        && apt-get -y autoremove \
        && apt-get clean autoclean \
        && rm -fr /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
# WARNING (2023-12-18): remove "xmpp" from  ntfy plugins because module SleekXMPP used for nom is not compatible Python >=3.10
# See: https://github.com/dschep/ntfy/issues/266

# Set the locale
RUN sed -i 's/# \(fr_FR\.UTF-8 .*\)/\1/' /etc/locale.gen \
    && touch /usr/share/locale/locale.alias \
        && locale-gen

# Copy script to create msmtprc config file
# msmtprc.sh will be executed in docker-entrypoint.sh at runtime
COPY ./msmtprc.sh /etc/borgmatic.d/msmtprc.sh
RUN chmod 755 /etc/borgmatic.d/msmtprc.sh \
        && touch /var/log/msmtp.log \
        && chown root:msmtp /var/log/msmtp.log \
        && chmod 664 /var/log/msmtp.log \
        && ls -al /etc/borgmatic.d/

# Set Cron for borgmatic
# DON'T USE dot or dash in cron.d script file name howerer the script will never execute.
# DON'T add this cron file to crontab ! Crontab and /etc/cron.d are distinct ! Run two process !
COPY ./borgmatic.cron /etc/cron.d/borgmatic
RUN  chmod 0644 /etc/cron.d/borgmatic \
        && chown root: /etc/cron.d/borgmatic \
        && sed -i  "s/\${MAILTO}/${MAILTO}/" /etc/cron.d/borgmatic \
        && chmod u+s /usr/sbin/cron \
        && touch /var/log/cron.log

# Add Borgmatic autocompletion
RUN borgmatic --bash-completion > /usr/share/bash-completion/completions/borgmatic
#RUN borgmatic --bash-completion > $(pkg-config --variable=completionsdir bash-completion)/borgmatic

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
        && echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
        && echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc
RUN echo ' \n\
if ! shopt -oq posix; then\n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then\n\
    . /usr/share/bash-completion/bash_completion\n\
  elif [ -f /etc/bash_completion ]; then\n\
    . /etc/bash_completion\n\
  fi\n\
fi' >> /root/.bashrc

# Add Telegram send message script
COPY ./telegram-send.sh /usr/local/bin/telegram-send
RUN  chmod 0755 /usr/local/bin/telegram-send

# Prepare entry point script
COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

CMD ["/entrypoint.sh"]

