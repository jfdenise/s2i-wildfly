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
    mkdir -p /wildfly/deployments && mkdir -p /wildfly/standalone/configuration && \
    mkdir -p /opt/s2i/destination
ADD ./m2-repository $HOME/.m2/repository

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Add s2i wildfly customizations
ADD ./contrib/settings.xml $HOME/.m2/

# Install wildfly-s2i galleon-pack.
COPY ./wildfly-s2i-galleon-pack  /tmp/wildfly-s2i-galleon-pack
RUN mvn -f /tmp/wildfly-s2i-galleon-pack install -Dmaven.repo.local=$HOME/.m2/repository  

RUN mkdir /output && chown -R 1001:0 /output && chmod -R ug+rwX /output && \
    rm -rf /tmp/wildfly-s2i-galleon-pack && \
    chown -R 1001:0 /wildfly && chown -R 1001:0 $HOME && \
    chmod -R ug+rwX $HOME/.m2/repository && \
    chmod -R ug+rwX /wildfly && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage