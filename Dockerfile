
FROM debian:jessie-slim
MAINTAINER Sebastian Koltun

RUN apt-get update

RUN yes | apt-get install wget

  # Download OpenJDK 11
RUN wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

  #Unpack Java
RUN mkdir -p usr/local/java && tar zxf openjdk-11.0.2_linux-x64_bin.tar.gz -C /usr/local/java
RUN chown -R root:root usr/local/java/jdk-11.0.2/*
RUN chmod -R a+rx usr/local/java/jdk-11.0.2/*

  # Add jboss user
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
chmod 755 /opt/jboss

USER jboss

  # Set JAVA_HOME
ENV JAVA_INSTALL_DIR=/usr/local/java/jdk-11.0.2

  # Set the working directory to jboss
WORKDIR /opt/jboss

#switch to root user
USER root

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 13.0.0.Final
ENV WILDFLY_SHA1 3d63b72d9479fea0e3462264dd2250ccd96435f9
ENV JBOSS_HOME /opt/jboss/wildfly
ENV STANDALONE_CONF /opt/jboss/wildfly/bin/standalone.conf

#Download wildfly
RUN cd $HOME \
&& wget https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
&& sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
&& tar xf wildfly-$WILDFLY_VERSION.tar.gz \
&& mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
&& rm wildfly-$WILDFLY_VERSION.tar.gz \
&& chown -R jboss:0 ${JBOSS_HOME} \
&& chmod -R g+rw ${JBOSS_HOME}

RUN echo "JAVA_HOME=$JAVA_INSTALL_DIR" >> $STANDALONE_CONF \
&& echo "JAVA_OPTS="-Djava.net.preferIPv4Addresses=true -Djava.net.preferIPv4Stack=true"" >> $STANDALONE_CONF

#switch to jboss user
USER jboss

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
