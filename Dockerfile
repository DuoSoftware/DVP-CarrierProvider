FROM  phusion/baseimage:0.9.17

MAINTAINER  Author Name <author@email.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

RUN apt-get -y update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common

ENV JAVA_VER 8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
    apt-get update && \
    echo oracle-java${JAVA_VER}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default && \
    apt-get clean && \
    rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer

RUN update-java-alternatives -s java-8-oracle

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc
RUN apt-get install maven git -y
RUN git clone https://github.com/DuoSoftware/DVP-CarrierProvider.git /usr/local/src/carrierprovider
RUN cd /usr/local/src/carrierprovider;
RUN mvn package;
RUN add-apt-repository ppa:webupd8team/java
RUN /opt/glassfish4/bin/
RUN ./asadmin start-domain domain1
RUN ./asadmin deploy --force=true --user admin /usr/local/src/carrierprovider/target/carrierProvider.war







RUN git clone https://github.com/DuoSoftware/DVP-Contacts.git /usr/local/src/contacts
RUN cd /usr/local/src/contacts;
WORKDIR /usr/local/src/contacts
RUN npm install
EXPOSE 8893
CMD [ "node", "/usr/local/src/contacts/app.js" ]

