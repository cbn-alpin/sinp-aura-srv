#!/bin/bash

BKP_NAME=${1:-backup}
BKP_LIST=$2
CFG_FILE=${3:-/root/.dropbox_uploader}

CUR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
TMP_DIR="/tmp/"
DATE=$(date +"%d-%m-%Y_%H%M")
BKP_FILE="$TMP_DIR/${BKP_NAME}_$DATE.tar"
DROPBOX_UPLOADER="${CUR_DIR}/dropbox_uploader.sh"

tar cf "$BKP_FILE" $BKP_LIST
gzip "$BKP_FILE"

$DROPBOX_UPLOADER -f ${CFG_FILE} upload "$BKP_FILE.gz" /${BKP_NAME}

rm -fr "$BKP_FILE.gz"