#
# Dockerfile for Voyant Tools server
#
FROM openjdk:13-jdk-alpine
LABEL Stephen Houser <houser@bowdoin.edu>

ARG VOYANT_VERSION=VoyantServer2_4-M17
ARG VOYANT_URL="https://github.com/sgsinclair/VoyantServer/releases/latest/download/${VOYANT_VERSION}.zip"

# Fetch the bundled Voyant Server package and extract it in-place if 
WORKDIR /usr/src
RUN VERSION=`basename ${VOYANT_URL} .zip` &&\
	wget -q -O ${VERSION}.zip ${VOYANT_URL} &&\
	unzip -q ${VERSION}.zip -x "${VERSION}/data/*" && \
	mv ${VERSION} /usr/src/voyant && \
	rm -rf ${VERSION}.zip 

# Stage data directory with links from local to mounted data
# This is because Jetty puts temp files in the data directory and
# basically clutters up our actual data. 
# This should probably be fixed in VoyantServer itself.
RUN mkdir -p /usr/src/voyant/data && \
	ln -s /data/trombone5_2 /usr/src/voyant/data/trombone5_2 &&\
	ln -s /data/trombone-local-sources /usr/src/voyant/data/trombone-local-sources &&\
	ln -s /data/trombone-resources /usr/src/voyant/data/trombone-resources &&\
	ln -s /data/voyant-server /usr/src/voyant/data/voyant-server

# Copy over any local server-settings file
COPY server-settings.txt /usr/src/voyant/server-settings.txt

VOLUME /data
EXPOSE 8888

WORKDIR /usr/src/voyant
CMD ["java", "-jar", "VoyantServer.jar", "--headless=true"]