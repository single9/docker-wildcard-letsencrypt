FROM certbot/certbot

LABEL maintainer="k078264@gmail.com"

RUN apk -U upgrade \
    && apk add curl bash \
    iptables \
    ca-certificates \
    e2fsprogs \
    docker \
    && pip install certbot-dns-cloudflare \
    && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/gen-ssl.sh" ]