Docker Wildcard Certbot
=================

Get Let's Encrypt wildcard SSL certificates validated by DNS challenges.

**NOTE**

This project currently only support Cloudflare DNS challenges.

Usage
-----------

    docker pull single9/wildcard-letsencrypt

    docker run -it --rm \
        -v "$DIR/ssl:/etc/letsencrypt" \
        -e DOMAIN_NAME=<Your Domain Name> \
        -e CERTBOT_EMAIL=<Your email for certbot> \
        -e CLOUDFLARE_EMAIL=<Your cloudflare email> \
        -e CLOUDFLARE_API_KEY=<Your cloudflare api key> \
        -e SLACK_WEBHOOK=https://hooks.slack.com/services/XXXXXX/XXXXXX/XXXXXXXXXXXXXX \
        -e SLACK_WEBHOOK_CHANNEL=<SLACK_CHANNEL> \
        single9/wildcard-letsencrypt

Example

    docker run -it --rm \
        -v "$DIR/ssl:/etc/letsencrypt" \
        -e DOMAIN_NAME=example.com \
        -e CERTBOT_EMAIL=duye@example.com \
        -e CLOUDFLARE_EMAIL=duye@example.com \
        -e CLOUDFLARE_API_KEY=<API_KEY> \
        single9/wildcard-letsencrypt

### Reload NGINX Container

If you want reload NGINX container after certbot is finished, add the environment variable `NGINX_CONTAINER_NAME`.

    docker run -it --rm \
        -v "$DIR/ssl:/etc/letsencrypt" \
        -v /var/run/docker.sock:/var/run/docker.sock
        -e NGINX_CONTAINER_NAME=<Container Name> \
        -e DOMAIN_NAME=<Your Domain Name> \
        -e CERTBOT_EMAIL=<Your email for certbot> \
        -e CLOUDFLARE_EMAIL=<Your cloudflare email> \
        -e CLOUDFLARE_API_KEY=<Your cloudflare api key> \
        single9/wildcard-letsencrypt

### Staging

    docker run -it --rm \
        -v "$DIR/ssl:/etc/letsencrypt" \
        -e MODE=staging \
        -e DOMAIN_NAME=<Your Domain Name> \
        -e CERTBOT_EMAIL=<Your email for certbot> \
        -e CLOUDFLARE_EMAIL=<Your cloudflare email> \
        -e CLOUDFLARE_API_KEY=<Your cloudflare api key> \
        single9/wildcard-letsencrypt
