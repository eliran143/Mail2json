#!/bin/bash

# Disable SMTPUTF8, because libraries (ICU) are missing in alpine
postconf -e smtputf8_enable=no

# Update aliases database.
echo "mailtojson: \"|/sbin/mail2json.py -m\"" > /etc/postfix/aliases
postalias /etc/postfix/aliases

# Update virtual database
if [[ ! -z "$VIRTUAL" ]]; then
        echo "Setting up VIRTUAL domains:"
        virtual_domains=/etc/postfix/virtual
        rm -f $virtual_domains $virtual_domains.db > /dev/null
        touch $virtual_domains
        for i in "$VIRTUAL"; do
                echo -e "@$i\tmailtojson"
                echo -e "@$i\tmailtojson" >> $virtual_domains
        done
fi
postmap /etc/postfix/virtual
postconf -e "virtual_alias_maps = hash:$virtual_domains"

# Don't relay for any domains
postconf -e relay_domains=

# Set up host name
if [[ ! -z "$HOSTNAME" ]]; then
	postconf -e "myhostname=$HOSTNAME"
	postconf -e "mydomain=$HOSTNAME"
else
	postconf -# myhostname
fi

# Set up a relay host, if needed
if [[ ! -z "$RELAYHOST" ]]; then
	postconf -e relayhost=$RELAYHOST
else
	postconf -# relayhost
fi

# Set up my networks to list only networks in the local loopback range
network_table=/etc/postfix/network_table
touch $network_table
echo "$HOSTNAME    any_value" >  $network_table
postmap $network_table
postconf -e mynetworks=hash:$network_table

if [[ ! -z "$MYNETWORKS" ]]; then
        postconf -e relayhost=$MYNETWORKS
else
        postconf -e "mynetworks=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
fi

# Split with space
if [[ ! -z "$ALLOWED_SENDER_DOMAINS" ]]; then
	echo "Setting up allowed SENDER domains:"
	allowed_senders=/etc/postfix/allowed_senders
	rm -f $allowed_senders $allowed_senders.db > /dev/null
	touch $allowed_senders
	for i in "$ALLOWED_SENDER_DOMAINS"; do
		echo -e "\t$i"
		echo -e "$i\tOK" >> $allowed_senders
	done
	postmap $allowed_senders

fi

# Use 587 (submission)
sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf

/usr/sbin/postfix -c /etc/postfix start
