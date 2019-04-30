#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R 1001:0 $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

curl -v -L http://repo.maven.apache.org/maven2/com/redhat/red/offliner/offliner/1.6/offliner-1.6.jar > /tmp/offliner.jar
java -jar /tmp/offliner.jar --url http://192.168.1.25:8080/maven $SCRIPT_DIR/offliner.txt --dir $MAVEN_LOCAL_REPO > /dev/null
rm /tmp/offliner.jar

# required to have maven enabled.
source $JBOSS_CONTAINER_MAVEN_35_MODULE/scl-enable-maven

mvn -f $SCRIPT_DIR/wildfly-s2i-galleon-pack/pom.xml install -Dmaven.repo.local=$MAVEN_LOCAL_REPO

DEFAULT_SERVER=os-standalone-profile

mvn -f $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/pom.xml package -Dmaven.repo.local=$MAVEN_LOCAL_REPO -Dcom.redhat.xpaas.repo.jbossorg --settings $HOME/.m2/settings.xml

cp -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target/wildfly $JBOSS_HOME && rm -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target && \
    ln -s $JBOSS_HOME /wildfly
cp -r $JBOSS_HOME/standalone/deployments/* /deployments
rm -rf $JBOSS_HOME/standalone/deployments
ln -s /deployments $JBOSS_HOME/standalone/deployments

chown -R 1001:0 $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME 
chown -R 1001:0 $HOME
chmod -R ug+rwX $MAVEN_LOCAL_REPO
chmod -R ug+rw $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS