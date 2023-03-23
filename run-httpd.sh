#!/bin/bash

if [ -z ${WEB_FQDN} ]; then
	echo "Environment variable WEB_FQDN undefined"
	exit 1
elif [[ -z $KRB_REALM ]]; then
	echo "Environment variable KRB_REALM undefined"
	exit 1
fi

echo "
<VirtualHost *:8080>
	<Directory "/opt/app-root/www/">
           AllowOverride All
           DirectoryIndex index.html index.htm
           Options +Indexes
	</Directory>
        <Location />
            AuthType GSSAPI
            AuthName "GSSAPI Single Sign On Login"
            GssapiCredStore keytab:/opt/app-root/httpd.keytab
            Require valid-user
        </Location>
</VirtualHost>
" > /tmp/web-sso.conf
mv /tmp/web-sso.conf /opt/app-root/web-sso.conf

/usr/sbin/httpd $OPTIONS -DFOREGROUND
