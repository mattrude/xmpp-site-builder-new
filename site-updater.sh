#!/bin/bash

VERSION=`ejabberdctl status |tail -1 |awk '{ print $2 }'`
GITVERSION=`git --git-dir=/var/src/ejabberd/.git log |head -1 |awk '{print $2}'`
UPLOADDAYS=`grep -A1 mod_http_upload_quota /etc/ejabberd/ejabberd.yml |grep max_days |awk '{ print $2 }'`
UPLOADFSIZ=`grep -A8 "mod_http_upload:$" /etc/ejabberd/ejabberd.yml |grep max_size |awk '{ print $2 }' |awk '{ byte =$1 /1024/1024/1024; print byte " GB" }'`

for DOMAIN in mattrude.com therudes.com soderparr.com
do
  sed -i "s/^ejabberd-version.*/ejabberd-version: \"${VERSION}\"/g" /var/src/xmpp-site/config/${DOMAIN}.yml
  sed -i "s/^ejabberd-gitversion.*/ejabberd-gitversion: \"${GITVERSION}\"/g" /var/src/xmpp-site/config/${DOMAIN}.yml
  sed -i "s/^ejabberd-upload-days.*/ejabberd-upload-days: \"${UPLOADDAYS}\"/g" /var/src/xmpp-site/config/${DOMAIN}.yml
  sed -i "s/^ejabberd-upload-fsize.*/ejabberd-upload-fsize: \"${UPLOADFSIZ}\"/g" /var/src/xmpp-site/config/${DOMAIN}.yml
done

#/root/xmpp-site/update-site-content.sh

cd /var/src/xmpp-site/sites/lite/ && rm -rf /var/www/im.mattrude.com && bundle exec jekyll build -c /var/src/xmpp-site/config/mattrude.com.yml -q
cd /var/src/xmpp-site/sites/lite/ && rm -rf /var/www/im.soderparr.com && bundle exec jekyll build -c /var/src/xmpp-site/config/soderparr.com.yml -q
cd /var/src/xmpp-site/sites/lite/ && rm -rf /var/www/im.therudes.com && bundle exec jekyll build -c /var/src/xmpp-site/config/therudes.com.yml -q

chown -R www-data:www-data /var/www/im.mattrude.com /var/www/im.soderparr.com /var/www/im.therudes.com
rm -rf /var/www/im.mattrude.com/files /var/www/im.therudes.com/files /var/www/im.soderparr.com/files

#/etc/ejabberd/bin/update-tlsa.sh
#/etc/ejabberd/bin/update-domain-certs.sh

cd /var/src/xmpp-site
for domain in mattrude.com therudes.com soderparr.com; do sed "s/<---REPLACE-ME--->/${domain}/g" nginx.xmpp.config > /etc/nginx/sites-enabled/xmpp-${domain}.conf; done
