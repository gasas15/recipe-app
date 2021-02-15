FROM alipine:latest

ENV WILDFLY_VERSION 15.0.0.Final

COPY wildfly-15.0.0.Final.tar /opt/

RUN set -x \
    apk add --update && \
    apk add curl tar openjdk64-11.0.2 curl && \
    addgroup -g 101 -S wildfly && \
    adduser -S -D -H -u 101 /opt/wildfly -s /sbin/nologin -G wildfly -g wildfly wildfly && \
    cd /opt/ && \
    tar xvf wildfly-$WILDFLY-VERSION.tar && \
    mv wildfly-$WILDFLY-VERSION wildfly && \
    chown -R wildfly:wildfly /opt/wildfly && \
    rm -rf /tmp/* /var/cache/apk/* && \
    rm -rf /opt/wildfly-15.0.0.Final.tar
    
COPY recipe-app-0.0.1-SNAPSHOT.jar /opt/wildfly/standalone/deployments/

EXPOSE 8080 9990

USER wildfly

WORKDIR /opt/wildfly/

CMD ["/opt/wildfly/bin/standalone.sh", "-c", "standalone-full.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"
