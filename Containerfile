FROM centos:stream8
MAINTAINER My Self ( The Real Me )

RUN dnf install -y httpd mod_auth_gssapi && dnf clean all

COPY run-httpd.sh /usr/sbin/run-httpd.sh

RUN chmod a+x /usr/sbin/run-httpd.sh && \
    echo "PidFile /tmp/http.pid" >> /etc/httpd/conf/httpd.conf && \
    echo 'IncludeOptional /opt/app-root/*.conf' >> /etc/httpd/conf/httpd.conf && \
    sed -i "s/Listen\ 80/Listen\ 8080/g"  /etc/httpd/conf/httpd.conf && \
    sed -i "s/\"logs\/error_log\"/\/dev\/stderr/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/CustomLog \"logs\/access_log\"/CustomLog \/dev\/stdout/g" /etc/httpd/conf/httpd.conf && \
    mkdir /opt/app-root/ && chown apache:apache /opt/app-root/ && chmod 777 /opt/app-root/

USER apache

EXPOSE 8080
ENTRYPOINT ["/usr/sbin/run-httpd.sh"]
