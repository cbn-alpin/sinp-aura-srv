FROM telegraf:1.29.2

# ⚠ WARNING: Telegraf base image must be in same Debian version than Host
# See: https://github.com/influxdata/influxdata-docker/blob/master/telegraf/1.28/Dockerfile

LABEL maintainer "Jean-Pascal MILCENT <jp.milcent@cbn-alpin.fr>"

ARG TZ=${TZ:-Europe/Paris}
ARG TELEGRAF_PGCUSTOM_URL_ZIP
ARG POSTGRESQL_HOST
ARG POSTGRESQL_TELEGRAF_PWD
ARG PGCUSTOM_ADDRESS_REGEX=${PGCUSTOM_ADDRESS_REGEX:-'^address=[\"][\"]'}
ARG PGCUSTOM_ADDRESS=${PGCUSTOM_ADDRESS:-"address=\"host=${POSTGRESQL_HOST} user=telegraf password=${POSTGRESQL_TELEGRAF_PWD}\""}

ENV DEFAULT_TZ ${TZ}

# Install system packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    vim \
    unzip \
    python3 \
    python3-venv \
    wget && \
    apt-get clean autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
    && echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
    && echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i -r 's/^# (alias|export|eval)/\1/' /root/.bashrc

# Create /etc/telegraf/.bashrc and uncomment alias
RUN cp /etc/skel/.bashrc /etc/telegraf/ && \
    sed -i -r 's/^#(alias|export|eval)/\1/' /etc/telegraf/.bashrc

RUN cd /opt && \
    wget -q -O pg_custom_cbna.zip ${TELEGRAF_PGCUSTOM_URL_ZIP} && \
    unzip pg_custom_cbna.zip && \
    rm -f pg_custom_cbna.zip && \
    mv telegraf-execd-pg-custom-cbna pg-custom && \
    cd pg-custom && \
    python3 -m venv ./venv && \
    . ./venv/bin/activate && \
    pip install psycopg2-binary pytz dateutils pytoml && \
    deactivate && \
    sed -i "s#${PGCUSTOM_ADDRESS_REGEX}#${PGCUSTOM_ADDRESS}#g" /opt/pg-custom/postgresql_custom_data.conf

