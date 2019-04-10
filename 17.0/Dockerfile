# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 16.0.0 Final

FROM centos/s2i-base-centos7

MAINTAINER Adam Kaplan <adam.kaplan@redhat.com>

EXPOSE 8080

ENV WILDFLY_VERSION=16.0.0.Final \
    MAVEN_VERSION=3.5.4

LABEL io.k8s.description="Platform for building and running JEE applications on WildFly 16.0.0.Final" \
      io.k8s.display-name="WildFly 16.0.0.Final" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,wildfly,wildfly16" \
      io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Adam Kaplan <adam.kaplan@redhat.com>"

# Install Maven
RUN INSTALL_PKGS="tar unzip bc which lsof java-11-openjdk java-11-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /opt/s2i/destination && \
    curl -v -L http://download-ipv4.eng.brq.redhat.com/released/JBoss-middleware/eap7/7.2.0/jboss-eap-7.2.0-maven-repository.zip > eap-repository.zip

RUN unzip -q eap-repository.zip -d /tmp/ && rm eap-repository.zip
RUN mv /tmp/jboss-eap-7.2.0.GA-maven-repository/maven-repository $HOME/.m2/repository && rm -r /tmp/jboss-eap-7.2.0.GA-maven-repository
RUN find $HOME/.m2/repository/ \( -name "*-sources.jar" -o -name "*-sources.jar.*" \) -type f -delete

# Add s2i wildfly customizations
ADD ./contrib/settings.xml $HOME/.m2/

# Install wildfly-s2i galleon-pack. We can't until we build with galleon 4.0
# COPY ./wildfly-s2i-galleon-pack  /tmp/wildfly-s2i-galleon-pack
# RUN mvn -f /tmp/wildfly-s2i-galleon-pack install -Dmaven.repo.local=$HOME/.m2/repository

#Provision default wildfly server
COPY ./wildfly-s2i-server-provisioning  /tmp/wildfly-s2i-server-provisioning
RUN mvn -f /tmp/wildfly-s2i-server-provisioning package -Dmaven.repo.local=$HOME/.m2/repository
RUN mkdir -p /opt/jboss && cp -r /tmp/wildfly-s2i-server-provisioning/target/wildfly /opt/jboss/eap

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# The paths are wrong with s2i tha texpects /wildfly. All revisited when switching to EAP s2i for all.
RUN mkdir /s2i-output && chown -R 1001:0 /s2i-output && chmod -R ug+rwX /s2i-output && \
    rm -rf /tmp/wildfly-s2i-galleon-pack && \
    rm -rf /tmp/wildfly-s2i-server-provisioning && \
    chown -R 1001:0 /opt/jboss/eap && chown -R 1001:0 $HOME && \
    chmod -R ug+rwX $HOME/.m2/repository && \
    chmod -R ug+rwX /opt/jboss/eap && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage
