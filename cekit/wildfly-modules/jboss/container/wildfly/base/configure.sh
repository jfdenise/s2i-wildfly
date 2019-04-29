#!/bin/sh
# Configure module
set -e
INSTALL_PKGS="tar unzip bc which lsof java-11-openjdk java-11-openjdk-devel"
yum install -y --enablerepo=centosplus $INSTALL_PKGS
rpm -V $INSTALL_PKGS
yum clean all -y
curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local
ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn
