FROM certbot/certbot

LABEL maintainer="k078264@gmail.com"

RUN apk -U upgrade \
    && apk add curl

COPY ./dns-scripts/ /opt/dns-scripts/
COPY ./gen-ssl.sh /gen-ssl.sh

ENTRYPOINT [ "/gen-ssl.sh" ]