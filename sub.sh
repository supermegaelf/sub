#!/bin/bash

TEMPLATE_DIR="/var/lib/marzban/templates/subscription"
TEMPLATE_FILE="$TEMPLATE_DIR/index.html"
CONFIG_FILE="/opt/marzban/.env"

mkdir -p "$TEMPLATE_DIR" &&
wget -q https://raw.githubusercontent.com/supermegaelf/Marzban-Subscription-Page/main/index.html -O "$TEMPLATE_FILE" || {
    echo "Error: failed to download the template"
    exit 1
}

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: file $CONFIG_FILE not found"
    exit 1
fi

cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

sed -i 's/^# *CUSTOM_TEMPLATES_DIRECTORY="\/var\/lib\/marzban\/templates\/"/CUSTOM_TEMPLATES_DIRECTORY="\/var\/lib\/marzban\/templates\/"/' "$CONFIG_FILE"
sed -i 's/^# *SUBSCRIPTION_PAGE_TEMPLATE="subscription\/index.html"/SUBSCRIPTION_PAGE_TEMPLATE="subscription\/index.html"/' "$CONFIG_FILE"
sed -i 's/^# *SUB_UPDATE_INTERVAL = "12"/SUB_UPDATE_INTERVAL = "1"/' "$CONFIG_FILE"

read -p "Sub-Site domain: " PRIMARY_DOMAIN

if [ -z "$PRIMARY_DOMAIN" ]; then
    echo "Error: domain cannot be empty"
    exit 1
fi

sed -i "s|# XRAY_SUBSCRIPTION_URL_PREFIX = \"https://example.com\"|XRAY_SUBSCRIPTION_URL_PREFIX = \"https://$PRIMARY_DOMAIN\"|" "$CONFIG_FILE"

if command -v marzban &> /dev/null; then
    marzban restart
fi
