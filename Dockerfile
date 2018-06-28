FROM ubuntu

MAINTAINER Leonardo Soto, https://github.com/lsoton

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y net-tools && \
    apt-get install -y zip unzip curl lynx && \
	apt-get update

# Instalar Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
	
# Define  directorio.
WORKDIR /data

# Define variable JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#Jboss eap 7.0 /opt
ADD ./jboss-eap-7.0.0.tar.gz /opt

# Crear usuario jboss
RUN groupadd -r jboss && useradd -r -g jboss -m -d /opt/EAP-7.0.0 jboss

# Instalar variable EAP 7.0.0.GA

USER jboss

ENV HOME /opt/EAP-7.0.0

#Permiso de ejecucion
#RUN chmod +x $HOME/EAP-7.0.0/bin/standalone.sh

#Variable entorno
ENV JBOSS_HOME $HOME

#root
USER root

ENV HOME /opt/EAP-7.0.0
ENV JBOSS_HOME $HOME

RUN chmod +x $HOME/bin/standalone.sh &&\
    chown -R jboss:jboss $HOME

#Descompacta o gosu, para execusao em root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-amd64" \
    	&& chmod +x /usr/local/bin/gosu

# adiciona o java e o jboss no path do S.O
ENV PATH $PATH:$JAVA_HOME/bin:$JBOSS_HOME/bin

#
WORKDIR /opt/EAP-7.0.0

# Expor as portas do jboss e outros servicos
EXPOSE 22 5455 9999 8009 8080 8443 3528 3529 7500 45700 7600 57600 5445 23364 5432 8090 4447 4712 4713 9990 8787

RUN mkdir /etc/jboss-as
RUN mkdir /var/log/jboss/
RUN chown jboss:jboss /var/log/jboss/

COPY docker-entrypoint.sh /
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# Define default command.
CMD ["start-jboss"]
