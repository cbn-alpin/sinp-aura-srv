#!/bin/sh

cat >/etc/msmtprc << EOF
# Set default values for all following accounts.
defaults
auth             on
aliases          /etc/aliases
logfile          /var/log/msmtp.log

# Enable or disable TLS/SSL encryption.
tls              on
tls_starttls	 on
# tls_certcheck off
tls_trust_file   /etc/ssl/certs/ca-certificates.crt

account	default
host ${MAIL_RELAY_HOST}
port ${MAIL_PORT}
from ${MAIL_FROM}
user ${MAIL_USER}
password ${MAIL_PASSWORD}
EOF
