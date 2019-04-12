#
# Dockerfile for Voyant Tools server
#
FROM tomcat:9-jre11
LABEL Stephen Houser <houser@bowdoin.edu>

ARG CATALINA_BASE=/usr/local/tomcat

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install supervisor -y && \
	apt-get clean autoclean && apt-get autoremove && \
	rm -rf /var/lib/{apt,dpkg,cache,log}

COPY supervisord.conf /etc/supervisord.conf

# This version downloads and installs the latest release from GitHub
# ARG VOYANT_VERSION=VoyantServer2_4-M17
WORKDIR /tmp
RUN wget -q "https://github.com/sgsinclair/VoyantServer/releases/latest/download/${VOYANT_VERSION}.zip" && \
	unzip -qq ${VOYANT_VERSION}.zip && \
	rm -rf ${CATALINA_BASE}/webapps/ROOT/ && cp -r ${VOYANT_VERSION}/_app ${CATALINA_BASE}/webapps/ROOT && \
	rm -rf /tmp/${VOYANT_VERSION}.zip /tmp/${VOYANT_VERSION}

# This version deploys a locally compiled WAR versions
#RUN rm -rf ${CATALINA_BASE}/webapps/ROOT/
#COPY Voyant-2.0.0-SNAPSHOT.war ${CATALINA_BASE}/webapps/ROOT.war

EXPOSE 8080
