#!/bin/bash

read -p "Sub-Site domain: " PRIMARY_DOMAIN

if [ -z "$PRIMARY_DOMAIN" ]; then
    echo "Error: domain cannot be empty"
    exit 1
fi

env_file="/opt/marzban/.env"

if [ ! -f "$env_file" ]; then
    echo "Error: file $env_file not found"
    exit 1
fi

sed -i "s|# XRAY_SUBSCRIPTION_URL_PREFIX = \"https://example.com\"|XRAY_SUBSCRIPTION_URL_PREFIX = \"https://$PRIMARY_DOMAIN\"|" "$env_file"

marzban restart
