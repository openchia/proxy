FROM caddy:2.7.4-alpine

# Identify the maintainer of an image
LABEL maintainer="contact@openchia.io"

EXPOSE 80
EXPOSE 443

RUN rm -rf /tmp/build

COPY ./docker/caddy/Caddyfile /etc/Caddyfile.tpl
COPY ./docker/entrypoint.sh /

CMD ["sh", "/entrypoint.sh"]
