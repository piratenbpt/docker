#!/bin/bash

[ -z "$PASSWORD_WEBCHAT" ] && PASSWORD_WEBCHAT="$IRC_ENV_PASSWORD_WEBCHAT"

cd /qwebirc

function replaceParameter() {
        sed "s/{${1}}/$(echo $2 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/g"
}

cat config.py.sample \
	| replaceParameter "PASSWORD_WEBCHAT" "$PASSWORD_WEBCHAT" \
	> config.py

./compile.py
./run.py -n --port 80
