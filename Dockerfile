FROM ubuntu

MAINTAINER Leonardo Soto, https://github.com/lsoton

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y net-tools && \
    apt-get install -y zip unzip && \
	apt-get update

#Instalar jdk
RUN apt-get update && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y  oracle-java8-installer && \\
        apt-get update

    #add-apt-repository ppa:webupd8team/java && \
#    apt-get update
