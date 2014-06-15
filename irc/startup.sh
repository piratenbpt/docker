#!/bin/bash


# prepare configuration
function replaceParameter() {
	sed "s/{${1}}/$(echo $2 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/g"
}

cat /etc/charybdis/ircd.conf.sample \
	| replaceParameter "SERVERNAME" "$SERVERNAME" \
	| replaceParameter "SERVERDESC" "$SERVERDESC" \
	| replaceParameter "SERVERID" "$SERVERID" \
	| replaceParameter "NETWORKNAME" "$NETWORKNAME" \
	| replaceParameter "NETWORKDESC" "$NETWORKDESC" \
	| replaceParameter "ADMINNAME" "$ADMINNAME" \
	| replaceParameter "ADMINMAIL" "$ADMINMAIL" \
	| replaceParameter "ADMINDESC" "$ADMINDESC" \
	| replaceParameter "PASSWORD-CONNECT" "$PASSWORD_CONNECT" \
	| replaceParameter "PASSWORD-WEBCHAT" "$PASSWORD_WEBCHAT" \
	| replaceParameter "PASSWORD-OPER" "$PASSWORD_OPER" \
	> /etc/charybdis/ircd.conf

for i in $(env | grep "^REMOTE_" | awk -F_ '{ print $1"_"$2 }' | sort | uniq); do
	v="${i}_NAME";			name=${!v}
	v="${i}_TYPE";			type=${!v}
	v="${i}_HOST";			host=${!v}
	v="${i}_PORT";			port=${!v}
	v="${i}_PASSWORD_SEND";		password_send=${!v}
	v="${i}_PASSWORD_ACCEPT";	password_accept=${!v}

	if [ "$type" = "stunnel" ]; then
		stunnel4 -fd 0 <<EOT
[ircd]
client = yes
accept = 127.0.0.1:10001
connect = $host:$port
EOT
		type="raw"
		host="127.0.0.1"
		port="10001"

		# stunnel quite sucks.
		echo | nc $host $port
	fi

	if [ "$type" = "raw" ]; then
		cat >> /etc/charybdis/ircd.conf <<EOT
connect "$name" {
	host = "$host";
	port = "$port";
	send_password = "$password_send";
	accept_password = "$password_accept";
	hub_mask = "*";
	class = "server";
	flags = autoconn;
};
EOT
	fi
done

# start ircd
sudo -u charybdis /usr/bin/charybdis-ircd -foreground
