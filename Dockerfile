#
# Dockerfile for Voyant Tools server
#
FROM openjdk:13-jdk-alpine
LABEL Stephen Houser <houser@bowdoin.edu>

ARG VOYANT_VERSION=VoyantServer2_4-M17

WORKDIR /tmp
RUN wget -q "https://github.com/sgsinclair/VoyantServer/releases/latest/download/${VOYANT_VERSION}.zip" && \
	unzip -qq ${VOYANT_VERSION}.zip -x "${VOYANT_VERSION}/data/*" && \
	mkdir -p /usr/src && \
 	mv ${VOYANT_VERSION} /usr/src/voyant && \
 	rm -rf ${VOYANT_VERSION}.zip 

# Stage data directory with links from local to mounted data
# This is because Jetty puts temp files in the data directory and
# basically clutters up our actual data. 
# This should probably be fixed in VoyantServer itself.
RUN mkdir -p /usr/src/voyant/data && \
	ln -s /data/trombone5_2 /usr/src/voyant/data/trombone5_2 &&\
	ln -s /data/trombone-local-sources /usr/src/voyant/data/trombone-local-sources &&\
	ln -s /data/trombone-resources /usr/src/voyant/data/trombone-resources &&\
	ln -s /data/voyant-server /usr/src/voyant/data/voyant-server

WORKDIR /usr/src/voyant
COPY server-settings.txt server-settings.txt

VOLUME /data
EXPOSE 8888

CMD ["java", "-jar", "VoyantServer.jar", "--headless=true"]