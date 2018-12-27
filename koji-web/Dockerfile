from centos:7
ARG JAKIESHASLO=mypassword
run yum update -y && yum install koji koji-utils -y && yum clean all && \
    useradd kojiadmin && mkhomedir_helper kojiadmin
run yum install -y httpd mod_ssl mod_wsgi postgresql koji-web koji-hub rsyslog && yum clean all &&  \
    mkdir /opt/koji
copy ssl.cnf /opt/koji/openssl.cnf
copy koji-add-service-certs /usr/local/bin/koji-add-service-certs
copy koji-add-user-certs /usr/local/bin/koji-add-user-certs
copy startup.sh /usr/local/sbin/startup.sh
copy schema.sql /root/schema.sql
copy kojihub.conf /etc/httpd/conf.d/kojihub.conf
copy ssl.conf /etc/httpd/conf.d/ssl.conf
copy hub.conf /etc/koji-hub/hub.conf
copy web.conf /etc/kojiweb/web.conf
copy kojiweb.conf /etc/httpd/conf.d/kojiweb.conf
copy kojira.conf /etc/kojira/kojira.conf
copy wait-for-it.sh /usr/local/bin/wait-for-it.sh

run echo "db:5432:*:postgres:koji_postgre_admin" > /root/.pgpass && \
    echo "db:5432:koji:koji:"$JAKIESHASLO >> /root/.pgpass && \
    chmod 0600 /root/.pgpass && touch /.bootstrap

entrypoint /usr/local/sbin/startup.sh
