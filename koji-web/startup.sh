#!/bin/bash

if ! [ -d /etc/pki/koji ]
then
	mkdir /etc/pki/koji
	cd /etc/pki/koji/
        cp /opt/koji/openssl.cnf /etc/pki/koji/ssl.cnf
	mkdir {certs,private,confs}
	touch index.txt
	echo 01 > serial
	openssl genrsa -out private/koji_ca_cert.key 4096
	openssl req -config ssl.cnf -new -x509 -days 3650 -key private/koji_ca_cert.key -subj '/C=PL/ST=Mazowieckie/L=Warsaw/O=T-Mobile Sp. z. o. o. /CN=koji.intcloud.t-mobile.pl' -out koji_ca_cert.crt -extensions v3_ca

/usr/local/bin/koji-add-service-certs kojiweb
/usr/local/bin/koji-add-service-certs kojihub
/usr/local/bin/koji-add-service-certs kojiadmin
/usr/local/bin/koji-add-user-certs kojiadmin
/usr/local/bin/koji-add-service-certs kojid1.intcloud.t-mobile.pl
/usr/local/bin/koji-add-service-certs kojira
fi

if [ -f /.bootstrap ]
then
	echo "Sleep 10 secs to make postgresql come up" ; sleep 10

	createuser -h db  --no-superuser --no-createrole --no-createdb koji -U postgres 
	createdb -O koji koji -h db -U postgres 

	JAKIESHASLO=$(cat /root/.pgpass | grep :koji: | awk -F: '{print $NF}') 
	psql -c "alter user koji with encrypted password '"$JAKIESHASLO"';" -h db -U postgres 
	psql -U koji -h db < /root/schema.sql 
	psql -U koji -h db -c "insert into users (name, status, usertype) values ('kojiadmin', 0, 0);" 
	psql -U koji -h db -c "insert into user_perms (user_id, perm_id, creator_id) values (1, 1, 1);"

	mkdir /mnt/koji/{packages,repos,work,scratch,repos-dist} -p 
	chown apache:apache /mnt/koji -R

	cp /etc/pki/koji/kojira.pem /etc/kojira/

	rm -f /.bootstrap
fi


wait-for-it.sh db:5432

rsyslogd
/usr/sbin/kojira --fg --force-lock --verbose &
httpd -DFOREGROUND -e info
tail -f /dev/null
