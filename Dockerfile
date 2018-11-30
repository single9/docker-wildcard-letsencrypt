FROM certbot/certbot

RUN apk -U upgrade \
    && apk add curl

COPY ./dns-scripts/ /opt/dns-scripts/
COPY ./gen-ssl.sh /gen-ssl.sh

ENTRYPOINT [ "/gen-ssl.sh" ]