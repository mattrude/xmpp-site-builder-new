#!/bin/bash

VERSION=`ejabberdctl status |tail -1 |awk '{ print $2 }'`
GITVERSION=`git --git-dir=/var/src/ejabberd/.git log |head -1 |awk '{print $2}'`

for DOMAIN in mattrude.com therudes.com soderparr.com
do
  sed -i "s/^ejabberd-version.*/ejabberd-version: \"${VERSION}\"/g" /root/xmpp-site/config/${DOMAIN}.yml
  sed -i "s/^ejabberd-gitversion.*/ejabberd-gitversion: \"${GITVERSION}\"/g" /root/xmpp-site/config/${DOMAIN}.yml
done

/root/xmpp-site/update-site-content.sh

cd /root/xmpp-site/sites/lite/ && rm -rf /var/www/im.mattrude.com && bundle exec jekyll build -c /root/xmpp-site/config/mattrude.com.yml -q
cd /root/xmpp-site/sites/lite/ && rm -rf /var/www/im.soderparr.com && bundle exec jekyll build -c /root/xmpp-site/config/soderparr.com.yml -q
cd /root/xmpp-site/sites/lite/ && rm -rf /var/www/im.therudes.com && bundle exec jekyll build -c /root/xmpp-site/config/therudes.com.yml -q

rm -rf /var/www/im.mattrude.com/files /var/www/im.therudes.com/files /var/www/im.soderparr.com/files

/etc/ejabberd/bin/update-certs.sh > /dev/null 2> /dev/null
/etc/ejabberd/bin/update-tlsa.sh
