#!/bin/bash


CUR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
DU_URL="https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh"

# Shell color
RCol="\e[0m";# Text Reset
Red="\e[1;31m"; # Text Dark Red
Gre="\e[1;32m"; # Text Dark Green
Yel="\e[1;33m"; # Text Yellow
Gra="\e[1;30m"; # Text Dark Gray
Whi="\e[1;37m"; # Text Dark White


if ! [ -f "${CUR_DIR}/dropbox_uploader.sh" ]; then
    echo -e "${Yel}Téléchargement du fichier dropbox_uploader.sh...${RCol}"
    wget $DU_URL -O "${CUR_DIR}/dropbox_uploader.sh"
    chmod +x "${CUR_DIR}/dropbox_uploader.sh"
fi

if ! [ -f "/etc/cron.d/bkp2dbx" ]; then
    echo -e "${Yel}Copie du bkp2dbx.cron to /etc/cron.d/...${RCol}"
    cp "${CUR_DIR}/bkp2dbx.cron" "/etc/cron.d/bkp2dbx"
fi
