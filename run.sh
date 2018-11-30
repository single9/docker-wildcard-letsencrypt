#!/bin/bash
#
# Author: Duye Chen
#

if [ -z $1 ]
then
    echo "Usage: ./run.sh [DOMAIN_NAME]"
    exit
fi

DOMAIN_NAME=$1
PATH=$PATH
DIR=`pwd`

########## Modify THIS SECTION #############
# MODE="staging"
CERTBOT_EMAIL="<Email>"
CLOUDFLARE_EMAIL="<Cloudflare Email>"
CLOUDFLARE_API_KEY="<Cloudflare global API key>"
############################################

docker run -it --rm \
    -v "$DIR/ssl:/etc/letsencrypt" \
    -e DOMAIN_NAME=$DOMAIN_NAME \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY \
    -e CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL \
    -e MODE=$MODE \
    wildcard-certbot