#!/bin/bash
#sh /tmp/eap-modules/jboss/container/user/configure.sh
sh /tmp/eap-modules/jboss/container/util/logging/bash/configure.sh
sh /tmp/eap-modules/jboss/container/java/jvm/bash/configure.sh
sh /tmp/eap-modules/jboss/container/maven/s2i/bash/configure.sh
sh /tmp/eap-modules/jboss/container/s2i/core/bash/configure.sh
sh /tmp/eap-modules/jboss/container/maven/default/bash/configure.sh
sh /tmp/eap-modules/jboss/container/eap/s2i/bash/configure.sh

echo DONE
