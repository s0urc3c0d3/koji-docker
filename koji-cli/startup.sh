#!/bin/bash

if [ -f /.bootstrap ]
then
	echo "Waiting until koji will start the first time"
	sleep 15

	su - kojiadmin -c 'mkdir ~/.koji ; cp /etc/pki/koji/kojiadmin.pem ~/.koji/client.crt ; cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/clientca.crt ; cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/serverca.crt'

cat > /home/kojiadmin/.koji/config << EOF
[koji]

;url of XMLRPC server
server = http://kojihub/kojihub

;url of web interface
weburl = http://kojihub/koji

;url of package download site
topurl = http://kojihub/kojifiles

;path to the koji top directory
topdir = /mnt/koji

authtype=ssl
; configuration for Kerberos authentication

;the service name of the principal being used by the hub
;krbservice = host

; configuration for SSL athentication

;client certificate
cert = ~/.koji/client.crt

;certificate of the CA that issued the client certificate
ca = ~/.koji/clientca.crt

;certificate of the CA that issued the HTTP server certificate
serverca = ~/.koji/serverca.crt
EOF
	kojihub=$(ping koji-web -c 1 | awk '{if (NR==1) {print $3}}' | sed -e "s/(//g" -e "s/)//g")
	echo "$kojihub   kojihub" >> /etc/hosts

	wait-for-it.sh koji-web:80

	chown kojiadmin:kojiadmin /home/kojiadmin/.koji/config

	koji-add-new-host kojid1.intcloud.t-mobile.pl

	su - kojiadmin -c 'koji add-user kojira'
	su - kojiadmin -c 'koji grant-permission repo kojira'

	rm -f /.bootstrap

fi

tail -f /dev/null
