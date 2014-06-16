#!/bin/bash

[ -z "$PASSWORD_CONNECT" ] && PASSWORD_CONNECT="$IRC_ENV_PASSWORD_CONNECT"
[ -z "$PASSWORD_WEBCHAT" ] && PASSWORD_WEBCHAT="$IRC_ENV_PASSWORD_WEBCHAT"
[ -z "$NETWORKNAME" ] && NETWORKNAME="$IRC_ENV_NETWORKNAME"
[ -z "$ADMINMAIL" ] && ADMINMAIL="$IRC_ENV_ADMINMAIL"

cd /qwebirc

function replaceParameter() {
        sed "s/{${1}}/$(echo $2 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/g"
}

cat config.py.sample \
	| replaceParameter "PASSWORD_CONNECT" "$PASSWORD_CONNECT" \
	| replaceParameter "PASSWORD_WEBCHAT" "$PASSWORD_WEBCHAT" \
	| replaceParameter "NETWORKNAME" "$NETWORKNAME" \
	| replaceParameter "ADMINMAIL" "$ADMINMAIL" \
	> config.py

./compile.py
./run.py -n --port 80
