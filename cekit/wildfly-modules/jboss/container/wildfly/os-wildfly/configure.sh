#!/bin/sh
# Configure module
set -e
SCRIPT_DIR=$(dirname $0)

# Download offliner runtime
curl -v -L http://repo.maven.apache.org/maven2/com/redhat/red/offliner/offliner/1.6/offliner-1.6.jar > /tmp/offliner.jar
java -jar /tmp/offliner.jar --url http://192.168.1.25:8080/maven $SCRIPT_DIR/offliner.txt --dir $MAVEN_LOCAL_REPO > /dev/null
rm /tmp/offliner.jar

# required to have maven enabled.
source $JBOSS_CONTAINER_MAVEN_35_MODULE/scl-enable-maven

# Copy JBOSS_HOME content (custom os content) to common package dir
cp -r $JBOSS_HOME/* $JBOSS_CONTAINER_WILDFLY_GALLEON_MODULE/wildfly-s2i-galleon-pack/src/main/resources/packages/wildfly.s2i.common/content
rm -rf $JBOSS_HOME/*

# Build WildFly s2i feature-pack and install it in local maven repository
# The active profiles are jboss-community-repository and securecentral
mvn -f $JBOSS_CONTAINER_WILDFLY_GALLEON_MODULE/wildfly-s2i-galleon-pack/pom.xml install \
-Dcom.redhat.xpaas.repo.jbossorg --settings $HOME/.m2/settings.xml -Dmaven.repo.local=$MAVEN_LOCAL_REPO

# Remove the feature-pack src
rm -rf $JBOSS_CONTAINER_WILDFLY_GALLEON_MODULE/wildfly-s2i-galleon-pack

# Provision the default server
DEFAULT_SERVER=os-standalone-profile

# The active profiles are jboss-community-repository and securecentral
mvn -f $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/pom.xml package -Dmaven.repo.local=$MAVEN_LOCAL_REPO \
-Dcom.redhat.xpaas.repo.jbossorg --settings $HOME/.m2/settings.xml

# Install WildFly server
rm -rf $JBOSS_HOME
cp -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target/wildfly $JBOSS_HOME
rm -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target
ln -s $JBOSS_HOME /wildfly

# link deployments
cp -r $JBOSS_HOME/standalone/deployments/* /deployments
rm -rf $JBOSS_HOME/standalone/deployments
ln -s /deployments $JBOSS_HOME/standalone/deployments

chown -R 1001:0 $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME 
chown -R 1001:0 $HOME
chmod -R ug+rwX $MAVEN_LOCAL_REPO
