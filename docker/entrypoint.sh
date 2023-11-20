#!/bin/sh
set -x

if [ ! -e "/etc/Caddyfile" ]; then
	if [ -z "${CERTBOT_EMAIL}" ]; then
		echo "CERTBOT_EMAIL required"
		exit 1
	fi

	if [ -n "${TLS_CERT}" -a -n "${TLS_KEY}" ]; then
		sed -i "s,%%TLS%%,tls ${TLS_CERT} ${TLS_KEY},g" /etc/Caddyfile.tpl
	else
		sed -i s,%%TLS%%,,g /etc/Caddyfile.tpl
	fi

	sed -i s,%%EMAIL%%,${CERTBOT_EMAIL},g /etc/Caddyfile.tpl
	sed -i s,%%WWW_DOMAIN%%,${WWW_DOMAIN:=localhost},g /etc/Caddyfile.tpl
	sed -i s,%%POOL_DOMAIN%%,${POOL_DOMAIN:=pool},g /etc/Caddyfile.tpl
	sed -i s,%%REDIRECT_DOMAIN%%,${REDIRECT_DOMAIN:=www},g /etc/Caddyfile.tpl
	sed -i s,%%API_HOSTNAME%%,${API_HOSTNAME:=api},g /etc/Caddyfile.tpl
	sed -i s,%%POOL_HOSTNAME%%,${POOL_HOSTNAME:=pool},g /etc/Caddyfile.tpl
	sed -i s,%%WEB_HOSTNAME%%,${WEB_HOSTNAME:=web},g /etc/Caddyfile.tpl
	sed -i s,%%TRUSTED_PROXIES%%,${TRUSTED_PROXIES},g /etc/Caddyfile.tpl
	sed -i s,%%LOGFORMAT,${LOGFORMAT:=json},g /etc/Caddyfile.tpl
	sed -i s,%%LOGLEVEL%%,${LOGLEVEL:=INFO},g /etc/Caddyfile.tpl

	# Allow a second pool domain
	if [ -n "${POOL2_DOMAIN}" ]; then
		sed -i s,%%POOL2_DOMAIN%%,${POOL2_DOMAIN},g /etc/Caddyfile.tpl
		sed -i s,%%POOL2_DOMAIN_END%%,,g /etc/Caddyfile.tpl
	else
		sed -i '/%%POOL2_DOMAIN%%/,/%%POOL2_DOMAIN_END%%/c' /etc/Caddyfile.tpl
	fi

	mv /etc/Caddyfile.tpl /etc/Caddyfile
else
	rm -f /etc/Caddyfile.tpl
fi

exec caddy run --config /etc/Caddyfile
