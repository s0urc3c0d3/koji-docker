#!/bin/bash

wait-for-it.sh koji-web:80

sleep 10

unalias cp 
kojihub=$(ping koji-web -c 1 | awk '{if (NR==1) {print $3}}' | sed -e "s/(//g" -e "s/)//g")
echo "$kojihub   kojihub" >> /etc/hosts
cp /etc/pki/koji/kojid1.intcloud.t-mobile.pl.pem /etc/kojid/
/usr/sbin/kojid --fg --force-lock --verbose

tail -f /dev/null
