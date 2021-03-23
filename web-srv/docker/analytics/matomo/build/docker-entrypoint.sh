#!/bin/sh
set -e

if [ ! -e matomo.php ]; then
	tar cf - --one-file-system -C /usr/src/matomo . | tar xf -
	chown -R www-data:www-data .
fi

# Start cron - Add by jpmilcent
service cron start

exec "$@"
