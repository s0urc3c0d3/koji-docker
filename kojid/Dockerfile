from centos:7
run yum update -y && yum install koji koji-utils koji-builder -y && yum clean all

#copy kojid.conf /etc/kojid/kojid.conf
copy startup.sh /usr/local/bin/startup.sh
copy kojid.conf /etc/kojid/kojid.conf
copy wait-for-it.sh /usr/local/bin/wait-for-it.sh

cmd /usr/local/bin/startup.sh
