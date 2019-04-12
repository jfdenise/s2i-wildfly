# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 17.0.0 Final

FROM centos/s2i-base-centos7

MAINTAINER Adam Kaplan <adam.kaplan@redhat.com>

EXPOSE 8080

ENV WILDFLY_VERSION=17.0.0.Final \
    MAVEN_VERSION=3.5.4 \
    JBOSS_CONTAINER_UTIL_LOGGING_MODULE=/opt/jboss/container/util/logging \
    JBOSS_CONTAINER_MAVEN_S2I_MODULE=/opt/jboss/container/maven/s2i/ \
    JBOSS_CONTAINER_EAP_S2I_MODULE=/opt/jboss/container/eap/s2i \
    JBOSS_CONTAINER_S2I_CORE_MODULE=/opt/jboss/container/s2i/core \
    JBOSS_CONTAINER_MAVEN_DEFAULT_MODULE=/opt/jboss/container/maven/default/ \
    S2I_SOURCE_DEPLOYMENTS_FILTER="*.war *.ear *.rar *.jar" \
    DEPLOYMENTS_DIR=/opt/jboss/wildfly/standalone/deployments \
    JBOSS_HOME=/opt/jboss/wildfly \
    MAVEN_LOCAL_REPO=$HOME/.m2/repository

LABEL io.k8s.description="Platform for building and running JEE applications on WildFly 17.0.0.Final" \
      io.k8s.display-name="WildFly 17.0.0.Final" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,wildfly,wildfly17" \
      io.openshift.s2i.destination="/tmp" \
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
    curl -v -L https://github.com/jfdenise/galleon-openshift/releases/download/1.0/repository.zip > repository.zip && \
    unzip -q repository.zip -d $HOME/.m2 && rm repository.zip

# Add s2i wildfly customizations
ADD ./contrib/settings.xml $HOME/.m2/

# Install wildfly-s2i galleon-pack.
COPY ./wildfly-s2i-galleon-pack  /tmp/wildfly-s2i-galleon-pack
RUN mvn -f /tmp/wildfly-s2i-galleon-pack install -Dmaven.repo.local=$HOME/.m2/repository && rm -r /tmp/wildfly-s2i-galleon-pack

# Install galleon descriptions.
COPY ./galleon /galleon

# Provision default server
RUN mvn -f /galleon/default package -Dmaven.repo.local=$HOME/.m2/repository
RUN mkdir -p /opt/jboss && cp -r /galleon/default/target/wildfly $JBOSS_HOME && rm -r /galleon/default/target && \
    ln -s $JBOSS_HOME /wildfly 

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./eap-modules/opt /opt
COPY ./eap-modules/usr/local/s2i $STI_SCRIPTS_PATH

RUN mkdir /s2i-output && chown -R 1001:0 /s2i-output && chmod -R ug+rwX /s2i-output && \
    chown -R 1001:0 $JBOSS_HOME && chown -R 1001:0 $HOME && \
    chmod -R ug+rwX $HOME/.m2/repository && \
    chmod -R ug+rwX $JBOSS_HOME && \
    chmod -R g+rw /opt/s2i/destination && \
    chmod -R g+rw /galleon

USER 1001

CMD $STI_SCRIPTS_PATH/usage