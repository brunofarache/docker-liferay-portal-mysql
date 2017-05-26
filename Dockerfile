FROM openjdk:8-jdk
MAINTAINER Bruno Farache <bruno.farache@liferay.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LIFERAY_HOME=/liferay
ENV LIFERAY_TOMCAT_URL=https://sourceforge.net/projects/lportal/files/Liferay%20Portal/7.0.2%20GA3/liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip/download

# Install packages
RUN apt-get update && \
  apt-get -y install curl supervisor unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  useradd -ms /bin/bash liferay

# Add image configuration and scripts
ADD start-tomcat.sh /start-tomcat.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD supervisord-tomcat.conf /etc/supervisor/conf.d/supervisord-tomcat.conf

# Configure /liferay folder
RUN mkdir -p "$LIFERAY_HOME"
WORKDIR $LIFERAY_HOME
RUN set -x && \
  curl -fSL "$LIFERAY_TOMCAT_URL" -o liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip && \
	unzip liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip && \
	rm liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip && \
  cp -R $LIFERAY_HOME/liferay-ce-portal-7.0-ga3/* $LIFERAY_HOME/ && \
  rm -fr $LIFERAY_HOME/liferay-ce-portal-7.0-ga3

ADD portal-ext.properties $LIFERAY_HOME/portal-ext.properties

RUN chown -R liferay:liferay $LIFERAY_HOME

VOLUME  ["/liferay/data"]

EXPOSE 8080 3306

CMD ["/run.sh"]