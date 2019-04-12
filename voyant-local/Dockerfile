#
# Dockerfile for Voyant Tools server
#
FROM tomcat:9-jre11
LABEL Stephen Houser <houser@bowdoin.edu>

ARG VOYANT_VERSION=Voyant-2.0.0-SNAPSHOT

ARG CATALINA_BASE=/usr/local/tomcat

# Install and configure `supervisord`, remove default Tomcat webapps
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install supervisor -y && \
	apt-get clean autoclean && apt-get autoremove && \
	rm -rf /var/lib/{apt,dpkg,cache,log} && \
	rm -rf ${CATALINA_BASE}/webapps/*

COPY supervisord.conf /etc/supervisord.conf

# Install and configure a locally compiled WAR version
COPY Voyant-2.0.0-SNAPSHOT.war ${CATALINA_BASE}/webapps/ROOT.war

EXPOSE 8080
