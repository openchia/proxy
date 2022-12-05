FROM caddy:2.6.2-alpine

# Identify the maintainer of an image
LABEL maintainer="contact@openchia.io"

EXPOSE 80
EXPOSE 443

RUN rm -rf /tmp/build

COPY ./Caddyfile /etc/
COPY ./entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
