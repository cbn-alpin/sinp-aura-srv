#!/bin/bash
# Source: https://bogomolov.tech/Telegram-notification-on-SSH-login/

# Note: TELEGRAM_GROUP_ID and TELEGRAM_BOT_TOKEN are set in .env file
TELEGRAM_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

# This 3 checks (if) are not necessary but should be convenient
if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` \"text message\""
  exit 0
fi

if [ -z "$1" ]
  then
    echo "Add message text as second arguments"
    exit 0
fi

if [ "$#" -ne 1 ]; then
    echo "You can pass only one argument. For string with spaces put it on quotes"
    exit 0
fi

# Send message
curl -s --data "text=$1" --data "chat_id=${TELEGRAM_GROUP_ID}" "${TELEGRAM_URL}" > /dev/null