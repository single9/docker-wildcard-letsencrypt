#!/bin/sh
#
# Usage: sudo ./create-ssl.sh [DOMAIN_NAME]
# Your SSL files is here: ./ssl
#
# Author: Duye Chen

if [ -z $DOMAIN_NAME ]
then
    echo "Domain name is undefined"
    exit
fi

DOMAIN_NAME="$DOMAIN_NAME"
PATH=$PATH
DIR=`pwd`
ACME_SERVER="https://acme-v02.api.letsencrypt.org/directory"

if [ "$MODE" = "staging" ]
then
    ACME_SERVER="https://acme-staging-v02.api.letsencrypt.org/directory"
    # ARGS="--dry-run"
fi

echo "Generating..."

certbot certonly $ARGS \
    --agree-tos \
    --non-interactive \
    -m $CERTBOT_EMAIL \
    --manual-public-ip-logging-ok \
    --manual --preferred-challenges=dns \
    --manual-auth-hook /opt/dns-scripts/authenticator.sh \
    --manual-cleanup-hook /opt/dns-scripts/cleanup.sh \
    --server $ACME_SERVER \
    -d *.$DOMAIN_NAME

if [ "$SERVER" = "haproxy" ]
then
    echo "Haproxy ._.b"
    cat /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem \
        /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem \
    | tee /etc/letsencrypt/haproxy.pem &>/dev/null \
    && echo "Your pem file is generated!"
fi