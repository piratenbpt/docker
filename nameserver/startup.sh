#!/bin/bash

# create named.conf.options
(
echo	"options {"
echo	"	directory \"/var/cache/bind\";"
echo	"	forwarders {"
for i in ${FORWARDERS//,/ }; do
echo	"		$i;"
done
echo	"	};"
echo	"	dnssec-validation auto;"
echo	"	auth-nxdomain no;"
echo	"};"
for i in $(env | grep "^KEY_" | awk -F_ '{ print $1"_"$2 }' | sort | uniq); do
	v="${i}_KEY";		key=${!v}
	v="${i}_SECRET";	secret=${!v}

	echo	"key $key {"
	echo	"	algorithm hmac-md5;"
	echo	"	secret \"${secret}\";"
	echo	"};"
done
) > /etc/bind/named.conf.options

# create named.conf.local
for i in $(env | grep "^ZONE_SLAVE_" | awk -F_ '{ print $1"_"$2"_"$3 }' | sort | uniq); do
	v="${i}_ZONE";		zone=${!v}
	v="${i}_MASTERS";	masters=${!v}

	echo	"zone \"$zone\" {"
	echo	"	type slave;"
	echo	"	file \"/var/lib/bind/db.$zone\";"
	echo	"	masters {"
	(
	IFS=","
	for master in $masters; do
	echo	"		$master;"
	done
	)
	echo	"	};"
	echo	"};"
done > /etc/bind/named.conf.local

sudo -u bind named -f
