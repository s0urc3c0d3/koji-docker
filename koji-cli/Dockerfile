from centos:7
ARG JAKIESHASLO=mypassword
run yum update -y && yum install koji koji-utils -y && yum clean all && \
    useradd kojiadmin && mkhomedir_helper kojiadmin && mkdir /opt/koji
copy startup.sh /usr/local/sbin/startup.sh
copy koji-add-new-host /usr/local/bin/koji-add-new-host
copy wait-for-it.sh /usr/local/bin/wait-for-it.sh

run echo "db:5432:*:postgres:koji_postgre_admin" > /root/.pgpass && \
    echo "db:5432:koji:koji:"$JAKIESHASLO >> /root/.pgpass && \
    chmod 0600 /root/.pgpass && touch /.bootstrap

entrypoint /usr/local/sbin/startup.sh
