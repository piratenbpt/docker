#!/bin/bash

USERNAME="admin"
PASSWORD="blah"

if [ $(grep -ci $USERNAME /etc/shadow) -eq 0 ]; then
	useradd $USERNAME --system -G root,lpadmin --no-create-home
fi
echo "$USERNAME:$PASSWORD" | chpasswd

cupsd -f & PID=$!

# TODO add classes, printers, ...

fg $PID
