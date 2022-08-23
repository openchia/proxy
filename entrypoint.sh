#!/bin/sh
set -x

if [ -z "${CERTBOT_EMAIL}" ]; then
	echo "CERTBOT_EMAIL required"
	exit 1
fi

if [ -n "${TLS_CERT}" -a -n "${TLS_KEY}" ]; then
	sed -i "s,%%TLS%%,tls ${TLS_CERT} ${TLS_KEY},g" /etc/Caddyfile
else
	sed -i s,%%TLS%%,,g /etc/Caddyfile
fi

sed -i s,%%EMAIL%%,${CERTBOT_EMAIL},g /etc/Caddyfile
sed -i s,%%WWW_DOMAIN%%,${WWW_DOMAIN:=localhost},g /etc/Caddyfile
sed -i s,%%POOL_DOMAIN%%,${POOL_DOMAIN:=pool},g /etc/Caddyfile
sed -i s,%%REDIRECT_DOMAIN%%,${REDIRECT_DOMAIN:=www},g /etc/Caddyfile
sed -i s,%%API_HOSTNAME%%,${API_HOSTNAME:=api},g /etc/Caddyfile
sed -i s,%%POOL_HOSTNAME%%,${POOL_HOSTNAME:=pool},g /etc/Caddyfile
sed -i s,%%WEB_HOSTNAME%%,${WEB_HOSTNAME:=web},g /etc/Caddyfile
sed -i s,%%TRUSTED_PROXIES%%,${TRUSTED_PROXIES},g /etc/Caddyfile

# Allow a second pool domain e.g. pool-eu
if [ -n "${POOL2_DOMAIN}" ]; then
	sed -i s,%%POOL2_DOMAIN%%,${POOL2_DOMAIN},g /etc/Caddyfile
	sed -i s,%%POOL2_DOMAIN_END%%,,g /etc/Caddyfile
else
	sed -i '/%%POOL2_DOMAIN%%/,/%%POOL2_DOMAIN_END%%/c' /etc/Caddyfile
fi

exec caddy run --config /etc/Caddyfile
