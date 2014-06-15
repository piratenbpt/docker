#!/bin/bash


# prepare configuration
function replaceParameter() {
	sed "s/{${1}}/$(echo $2 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/g"
}

cat /etc/charybdis/ircd.conf.sample \
	| replaceParameter "PASSWORD-CONNECT" "$PASSWORD_CONNECT" \
	| replaceParameter "PASSWORD-WEBCHAT" "$PASSWORD_WEBCHAT" \
	| replaceParameter "PASSWORD-OPER" "$PASSWORD_OPER" \
	> /etc/charybdis/ircd.conf

# Add remote
[ "$REMOTE_TYPE" = "stunnel" ] && {
	stunnel4 -fd 0 <<EOT
[ircd]
client = yes
accept = 127.0.0.1:10001
connect = $REMOTE_HOST:$REMOTE_PORT
EOT
	REMOTE_TYPE="raw"
	REMOTE_HOST="127.0.0.1"
	REMOTE_PORT="10001"

	# stunnel quite sucks.
	nc $REMOTE_HOST $REMOTE_PORT <<EOT
EOT
}

[ "$REMOTE_TYPE" = "raw" ] && {
	cat >> /etc/charybdis/ircd.conf <<EOT
connect "vpn01.piratenpartei-hessen.de" {
	host = "$REMOTE_HOST";
	port = "$REMOTE_PASS";
	send_password = "$REMOTE_PASSWORD_SEND";
	accept_password = "$REMOTE_PASSWORD_ACCEPT";
	hub_mask = "*";
	class = "server";
	flags = autoconn;
};
EOT
}

# start ircd
sudo -u charybdis /usr/bin/charybdis-ircd -foreground
