#!/bin/bash

#rsync -a matt@im.mattrude.com:/etc/ejabberd/certs/mattrude.com /etc/ejabberd/certs/
#rsync -a matt@im.mattrude.com:/etc/ejabberd/certs/im.mattrude.com /etc/ejabberd/certs/
#rsync -a im.soderparr.com:/etc/ejabberd/certs/soderparr.com /etc/ejabberd/certs/
#rsync -a im.soderparr.com:/etc/ejabberd/certs/im.soderparr.com /etc/ejabberd/certs/

for DOMAIN in mattrude.com soderparr.com therudes.com
do
    ###
    ### The Primary Cert Tests
    ###
    DOMAINFL="im.${DOMAIN}"
    if [ -f /etc/ejabberd/certs/$DOMAIN/fullchain.pem ]; then
        if [ `openssl x509 -noout -text -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |grep "DNS:$DOMAIN" |wc -l` -gt 0 ]; then
            EXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-expires: "/g' |sed 's/$/"/g'`
            SHA1=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-sha1: "/g' |sed 's/$/"/g'`
            SHA256=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-sha256: "/g' |sed 's/$/"/g'`
        else
            EXPIRES='fingerprint-expires: "No Key Found"'
            SHA1='fingerprint-sha1: "No Key Found"'
            SHA256='fingerprint-sha256: "No Key Found"'
        fi
    else
        if [ -f /etc/ejabberd/certs/${DOMAIN}/fullchain.pem ]; then
            if [ `openssl x509 -noout -text -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |grep "DNS:$DOMAIN" |wc -l` -gt 0 ]; then
                EXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-expires: "/g' |sed 's/$/"/g'`
                SHA1=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-sha1: "/g' |sed 's/$/"/g'`
                SHA256=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/${DOMAIN}/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-sha256: "/g' |sed 's/$/"/g'`
            else
                EXPIRES='fingerprint-expires: "No Key Found"'
                SHA1='fingerprint-sha1: "No Key Found"'
                SHA256='fingerprint-sha256: "No Key Found"'
            fi
        fi
    fi
    sed -i "/fingerprint-expires/c$EXPIRES" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-sha1/c$SHA1" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-sha256/c$SHA256" /var/src/xmpp-site/config/$DOMAIN.yml

    ###
    ### The IM Cert Tests
    ###
    if [ -f /etc/letsencrypt/live/im.$DOMAIN/fullchain.pem ]; then
        IMEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/im.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-im-expires: "/g' |sed 's/$/"/g'`
        SHA1IM=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/im.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-im-sha1: "/g' |sed 's/$/"/g'`
        SHA256IM=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/im.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-im-sha256: "/g' |sed 's/$/"/g'`
    else
        if [ -f /etc/letsencrypt/live/$DOMAINFL/fullchain.pem ]; then
            IMEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-im-expires: "/g' |sed 's/$/"/g'`
            SHA1IM=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-im-sha1: "/g' |sed 's/$/"/g'`
            SHA256IM=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-im-sha256: "/g' |sed 's/$/"/g'`
        else
            if [ -f /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem ]; then
                IMEXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-im-expires: "/g' |sed 's/$/"/g'`
                SHA1IM=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-im-sha1: "/g' |sed 's/$/"/g'`
                SHA256IM=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-im-sha256: "/g' |sed 's/$/"/g'`
            else
                IMEXPIRES='fingerprint-im-expires: "No Key Found"'
                SHA1IM='fingerprint-im-sha1: "No Key Found"'
                SHA256IM='fingerprint-im-sha256: "No Key Found"'
            fi
        fi
    fi
    sed -i "/fingerprint-im-expires/c$IMEXPIRES" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-im-sha1/c$SHA1IM" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-im-sha256/c$SHA256IM" /var/src/xmpp-site/config/$DOMAIN.yml

    ###
    ### The Conference Cert Tests
    ###
    if [ -f /etc/letsencrypt/live/conference.$DOMAIN/fullchain.pem ]; then
        CONFERENCEEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/conference.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-conference-expires: "/g' |sed 's/$/"/g'`
        SHA1CONFERENCE=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/conference.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-conference-sha1: "/g' |sed 's/$/"/g'`
        SHA256CONFERENCE=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/conference.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-conference-sha256: "/g' |sed 's/$/"/g'`
    else
        if [ -f /etc/letsencrypt/live/$DOMAINFL/fullchain.pem ]; then
            CONFERENCEEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-conference-expires: "/g' |sed 's/$/"/g'`
            SHA1CONFERENCE=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-conference-sha1: "/g' |sed 's/$/"/g'`
            SHA256CONFERENCE=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-conference-sha256: "/g' |sed 's/$/"/g'`
        else
            if [ -f /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem ]; then
                CONFERENCEEXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-conference-expires: "/g' |sed 's/$/"/g'`
                SHA1CONFERENCE=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-conference-sha1: "/g' |sed 's/$/"/g'`
                SHA256CONFERENCE=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-conference-sha256: "/g' |sed 's/$/"/g'`
            else
                CONFERENCEEXPIRES='fingerprint-conference-expires: "No Key Found"'
                SHA1CONFERENCE='fingerprint-conference-sha1: "No Key Found"'
                SHA256CONFERENCE='fingerprint-conference-sha256: "No Key Found"'
            fi
        fi
    fi
    sed -i "/fingerprint-conference-expires/c$CONFERENCEEXPIRES" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-conference-sha1/c$SHA1CONFERENCE" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-conference-sha256/c$SHA256CONFERENCE" /var/src/xmpp-site/config/$DOMAIN.yml

    ###
    ### The Proxy Cert Tests
    ###
    if [ -f /etc/letsencrypt/live/proxy.$DOMAIN/fullchain.pem ]; then
        PROXYEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/proxy.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-proxy-expires: "/g' |sed 's/$/"/g'`
        SHA1PROXY=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/proxy.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-proxy-sha1: "/g' |sed 's/$/"/g'`
        SHA256PROXY=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/proxy.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-proxy-sha256: "/g' |sed 's/$/"/g'`
    else
        if [ -f /etc/letsencrypt/live/im.${DOMAIN}/fullchain.pem ]; then
            PROXYEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/im.${DOMAIN}/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-proxy-expires: "/g' |sed 's/$/"/g'`
            SHA1PROXY=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/im.${DOMAIN}/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-proxy-sha1: "/g' |sed 's/$/"/g'`
            SHA256PROXY=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/im.${DOMAIN}/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-proxy-sha256: "/g' |sed 's/$/"/g'`
        else
            if [ -f /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem ]; then
                PROXYEXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-proxy-expires: "/g' |sed 's/$/"/g'`
                SHA1PROXY=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-proxy-sha1: "/g' |sed 's/$/"/g'`
                SHA256PROXY=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-proxy-sha256: "/g' |sed 's/$/"/g'`
            else
                PROXYEXPIRES='fingerprint-proxy-expires: "No Key Found"'
                SHA1PROXY='fingerprint-proxy-sha1: "No Key Found"'
                SHA256PROXY='fingerprint-proxy-sha256: "No Key Found"'
            fi
        fi
    fi
    sed -i "/fingerprint-proxy-expires/c$PROXYEXPIRES" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-proxy-sha1/c$SHA1PROXY" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-proxy-sha256/c$SHA256PROXY" /var/src/xmpp-site/config/$DOMAIN.yml

    ###
    ### The Upload Cert Tests
    ###
    if [ -f /etc/letsencrypt/live/upload.$DOMAIN/fullchain.pem ]; then
        UPLOADEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/upload.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-upload-expires: "/g' |sed 's/$/"/g'`
        SHA1UPLOAD=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/upload.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-upload-sha1: "/g' |sed 's/$/"/g'`
        SHA256UPLOAD=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/upload.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-upload-sha256: "/g' |sed 's/$/"/g'`
    else
        if [ -f /etc/letsencrypt/live/$DOMAINFL/fullchain.pem ]; then
            UPLOADEXPIRES=`openssl x509 -noout -text -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-upload-expires: "/g' |sed 's/$/"/g'`
            SHA1UPLOAD=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-upload-sha1: "/g' |sed 's/$/"/g'`
            SHA256UPLOAD=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/letsencrypt/live/$DOMAINFL/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-upload-sha256: "/g' |sed 's/$/"/g'`
        else
            if [ -f /etc/ejabberd/certs/im.${DOMAIN}/fullchain.pem ]; then
                UPLOADEXPIRES=`openssl x509 -noout -text -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |grep "Not After : " |sed 's/            Not After : /fingerprint-upload-expires: "/g' |sed 's/$/"/g'`
                SHA1UPLOAD=`openssl x509 -noout -fingerprint -sha1 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA1 Fingerprint=/fingerprint-upload-sha1: "/g' |sed 's/$/"/g'`
                SHA256UPLOAD=`openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/ejabberd/certs/im.$DOMAIN/fullchain.pem |sed 's/SHA256 Fingerprint=/fingerprint-upload-sha256: "/g' |sed 's/$/"/g'`
            else
                UPLOADEXPIRES='fingerprint-upload-expires: "No Key Found"'
                SHA1UPLOAD='fingerprint-upload-sha1: "No Key Found"'
                SHA256UPLOAD='fingerprint-upload-sha256: "No Key Found"'
            fi
        fi
    fi
    sed -i "/fingerprint-upload-expires/c$UPLOADEXPIRES" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-upload-sha1/c$SHA1UPLOAD" /var/src/xmpp-site/config/$DOMAIN.yml
    sed -i "/fingerprint-upload-sha256/c$SHA256UPLOAD" /var/src/xmpp-site/config/$DOMAIN.yml
done
