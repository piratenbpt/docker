#!/bin/bash

if [ $(grep -ci $USERNAME /etc/shadow) -eq 0 ]; then
	useradd $USERNAME --system -G root,lpadmin --no-create-home
fi
echo "$USERNAME:$PASSWORD" | chpasswd

cupsd -f & PID=$!

sleep 1

# Add printers
for i in $(env | grep "^PRINTER_" | awk -F_ '{ print $1"_"$2 }' | sort | uniq); do
	v="${i}_NAME";		name="${!v}"
	v="${i}_DEVICE";	device="${!v}"
	v="${i}_PPD";		ppd="${!v}"
	v="${i}_CLASSES";	classes="${!v}"

	[ -z "$ppd" ] \
		&& lpadmin -p "$name" -E -v "$device" \
		|| lpadmin -p "$name" -E -v "$device" -m "$ppd"

	for class in $classes; do
		lpadmin -p "$name" -c "$class"
	done
done

wait $PID
