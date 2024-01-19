#!/bin/bash

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "   .|||||||||.          .|||||||||."
echo "  |||||||||||||        |||||||||||||"
echo " |||||||||||' .\      /. '|||||||||||"
echo " '||||||||||_,__o    o__,_||||||||||'"
echo ""
echo " > GeoNature"
echo " > Biodiversité des territoires"
echo " > https://github.com/lpoaura/GeoNature-BiodivTerritoires"
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""

# Set default variables values
app_name="${app_name:-gnbt}"
gun_num_workers=${gun_num_workers:-4}
gun_timeout=${gun_timeout:-30}
gun_host=${gun_host:-0.0.0.0}
gun_port=${gun_port:-8080}

until [ "$(psql $(python -c 'print("'${SQLALCHEMY_DATABASE_URI}'".replace("+psycopg2",""))') -XtAc "SELECT 1")" = '1' ]; do
  echo "Awaiting Database container"
  sleep 1
done
sleep 2

cd /app

echo "DEBUG: ${DEBUG}"

if [ "${DEBUG}" == "true" ] ; then
  echo "Mode: debug"
  python -m wsgi
else
  echo "Mode: production"
  echo "Gunicorn config:"
  echo -e "\t app_name=${app_name}"
  echo -e "\t gun_num_workers=${gun_num_workers}"
  echo -e "\t gun_timeout=${gun_timeout}"
  echo -e "\t gun_host=${gun_host}"
  echo -e "\t gun_port=${gun_port}"

  gunicorn wsgi:app --error-log - --access-logfile - \
  	--pid="${app_name}.pid" \
	-w "${gun_num_workers}" \
	-t "${gun_timeout}" \
	-b "${gun_host}:${gun_port}" \
	-n "${app_name}"
fi
