FROM java:alpine
LABEL Description="Apache JMeter Server"
RUN apk update \ 
	&& apk add wget unzip

ENV JMETER_VERSION apache-jmeter-5.1.1
ENV JMETER_HOME /jmeter/${JMETER_VERSION}
ENV JMETER_BIN $JMETER_HOME/bin

ENV IP 127.0.0.1
ENV RMI_PORT 1099


RUN mkdir /jmeter

COPY ${JMETER_VERSION}.tgz /jmeter/

# Installing jmeter
RUN cd /jmeter/ \
    && tar -xzf ${JMETER_VERSION}.tgz \
    && rm ${JMETER_VERSION}.tgz

#RUN mkdir /jmeter-plugins \
#    && cd /jmeter-plugins/ \
#    && wget https://jmeter-plugins.org/downloads/file/${JMETER_PLUGINS}.zip \
#    && unzip -o ${JMETER_PLUGINS}.zip -d /jmeter/${JMETER_VERSION}/


ENV PATH $JMETER_HOME/bin:$PATH

RUN touch jmeter-server.log

# Ports required for JMeter Slaves/Server
EXPOSE 50000
EXPOSE $RMI_PORT

WORKDIR ${JMETER_HOME}

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# Application to be executed to start the JMeter container
#EXEC jmeter-server \
#    -Dserver.rmi.ssl.disable=true \
#    -Dserver.rmi.localport=50000 \
#	-Djava.rmi.server.hostname=${IP} \
#    -Dserver_port=1099