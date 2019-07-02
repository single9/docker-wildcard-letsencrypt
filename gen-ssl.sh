#!/bin/bash
#
# Author: Duye Chen

if [ -z $DOMAIN_NAME ] && [ -z $DOMAIN_NAMES ]
then
    echo "Domain name is undefined"
    exit
fi

CERTBOT_DOMAINS=""
DOMAIN_NAME="$DOMAIN_NAME"
NGINX_CONTAINER_NAME="$NGINX_CONTAINER_NAME"
PATH=$PATH
DIR=`pwd`
ACME_SERVER="https://acme-v02.api.letsencrypt.org/directory"

if [ -n "$DOMAIN_NAMES" ];
then
    IFS=', ' read -r -a array <<< "$DOMAIN_NAMES"
    DOMAIN_NAME=${array[0]}
    for i in "${!array[@]}"; do
        CERTBOT_DOMAINS="${CERTBOT_DOMAINS} -d ${array[i]}"
    done
else
    CERTBOT_DOMAINS="-d *.${DOMAIN_NAME} -d ${DOMAIN_NAME}"
fi

if [ "$MODE" = "staging" ]
then
    ACME_SERVER="https://acme-staging-v02.api.letsencrypt.org/directory"
    ARGS="--dry-run"
fi

echo "Generating..."

echo "dns_cloudflare_email = $CLOUDFLARE_EMAIL" >> /cloudflare.ini
echo "dns_cloudflare_api_key = $CLOUDFLARE_API_KEY" >> /cloudflare.ini

chmod 600 /cloudflare.ini

CERTBOT="certbot certonly $ARGS \
    --agree-tos \
    --non-interactive \
    -m $CERTBOT_EMAIL \
    --manual-public-ip-logging-ok \
    --dns-cloudflare \
    --dns-cloudflare-credentials /cloudflare.ini \
    --server $ACME_SERVER \
    --expand \
    $CERTBOT_DOMAINS"

if [ -n "$SLACK_WEBHOOK" ]
then
    $CERTBOT &> /certbot.log
    cat /certbot.log
else
    $CERTBOT
fi

if [ -n "$HAPROXY_CONTAINER_NAME" ]
then
    echo "Haproxy ._.b"
    cat /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem \
        /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem \
    | tee /etc/letsencrypt/live/$DOMAIN_NAME/haproxy.pem &>/dev/null \
    && echo "Reload Haproxy" \
    && docker kill -s HUP $HAPROXY_CONTAINER_NAME
fi

if [ -n "$NGINX_CONTAINER_NAME" ]
then
    echo 'Reload NGINX'
    docker exec -it $NGINX_CONTAINER_NAME nginx -s reload
fi

# Send to Slack
if [ -n "$SLACK_WEBHOOK" ]
then
    USER_NAME="$DOMAIN_NAME certbot"
    CERTBOT_LOG=$(sed 's/"/\\"/g' /certbot.log)
    SLACK_TEXT='Certbot is updated your SSL Certification'
    SLACK_TEXT="$SLACK_TEXT\n\`\`\`\n${CERTBOT_LOG}\n\`\`\`"

    curl -X POST --data-urlencode "payload={\"channel\": \"$SLACK_WEBHOOK_CHANNEL\", \"username\": \"$USER_NAME\", \"text\": \"${SLACK_TEXT}\"}" $SLACK_WEBHOOK
fi