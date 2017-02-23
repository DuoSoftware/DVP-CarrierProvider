FROM glassfish/openjdk
# Maintainer
# Set environment variables and default password for user 'admin'
ENV GLASSFISH_PKG=glassfish-4.1.1.zip \
    GLASSFISH_URL=http://download.oracle.com/glassfish/4.1.1/release/glassfish-4.1.1.zip \
    GLASSFISH_HOME=/glassfish4 \
    PATH=$PATH:/glassfish4/bin \
    PASSWORD=glassfish

# Install packages, download and extract GlassFish
# Setup password file
# Enable DAS
RUN apk add --update wget unzip git curl && \
    wget --no-check-certificate $GLASSFISH_URL && \
    unzip -o $GLASSFISH_PKG && \
    rm -f $GLASSFISH_PKG && \
    apk del wget unzip && \
    echo "--- Setup the password file ---" && \
    echo "AS_ADMIN_PASSWORD=" > /tmp/glassfishpwd && \
    echo "AS_ADMIN_NEWPASSWORD=${PASSWORD}" >> /tmp/glassfishpwd  && \
    echo "--- Enable DAS, change admin password, and secure admin access ---" && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1 && \
    asadmin start-domain && \
    echo "AS_ADMIN_PASSWORD=${PASSWORD}" > /tmp/glassfishpwd && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd enable-secure-admin && \
    asadmin --user=admin stop-domain && \
    rm /tmp/glassfishpwd

ENV PATH $PATH:/usr/local/apache-maven-3.3.9/bin

RUN curl -L -o /tmp/apache-maven-3.3.9.zip http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip && \
        unzip /tmp/apache-maven-3.3.9.zip -d /usr/local && \
        rm -f /tmp/apache-maven-3.3.9.zip

RUN git clone https://github.com/DuoSoftware/DVP-CarrierProvider.git /usr/src/carrierprovider
RUN cd /usr/src/carrierprovider
WORKDIR /usr/src/carrierprovider
RUN mvn package
RUN cp target/carrierProvider.war /glassfish4/glassfish/domains/domain1/autodeploy/
# Ports being exposed
EXPOSE 4848 8080 8181

# Start asadmin console and the domain
CMD ["asadmin", "start-domain", "-v"]
