#
# Dockerfile for Voyant Tools server
#
FROM tomcat:9-jre11
LABEL Stephen Houser <houser@bowdoin.edu>

ARG VOYANT_VERSION=VoyantServer2_4-M17
ARG VOYANT_URL="https://github.com/sgsinclair/VoyantServer/releases/latest/download/${VOYANT_VERSION}.zip"

ARG CATALINA_BASE=/usr/local/tomcat

# Install and configure `supervisord`, remove default Tomcat webapps
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install supervisor -y && \
	apt-get clean autoclean && apt-get autoremove && \
	rm -rf /var/lib/{apt,dpkg,cache,log} && \
	rm -rf ${CATALINA_BASE}/webapps/*

COPY supervisord.conf /etc/supervisord.conf

# Download and configure Voyant Tools web application within Tomcat
WORKDIR /tmp
RUN VOYANT=`basename ${VOYANT_URL} .zip` &&\
	wget -q -O ${VOYANT}.zip ${VOYANT_URL} &&\
	unzip -q ${VOYANT}.zip ${VOYANT}/_app/* && \
	mv ${VOYANT}/_app ${CATALINA_BASE}/webapps/ROOT && \
	rm -rf ${VOYANT}.zip ${VOYANT}

# Install and configure a locally compiled WAR version
#COPY Voyant-2.0.0-SNAPSHOT.war ${CATALINA_BASE}/webapps/ROOT.war

EXPOSE 8080
