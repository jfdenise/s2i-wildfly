#!/bin/bash
if [ -z "$CCT_MODULE_PATH" ]; then
  echo "No path to cct_module, set CCT_MODULES_PATH"
  exit 1
fi

if [ -z "$JBOSS_EAP_MODULES_PATH" ]; then
  echo "No path to jboss-eap-modules, set JBOSS_EAP_MODULES_PATH"
  exit 1
fi
DIRNAME=`dirname "$0"`
EAP_MODULES=$DIRNAME/eap-modules/
rm -rf $EAP_MODULES
mkdir -p $EAP_MODULES

# Common, user, can't be used. We already have an s2i user.
# mkdir -p $EAP_MODULES/jboss/container
# cp -r $CCT_MODULE_PATH/jboss/container/user $EAP_MODULES/jboss/container/user
# s2i
mkdir -p $EAP_MODULES/jboss/container/maven/s2i/
cp -r $CCT_MODULE_PATH/jboss/container/maven/s2i/bash $EAP_MODULES/jboss/container/maven/s2i/bash

mkdir -p $EAP_MODULES/jboss/container/util/logging/
cp -r $CCT_MODULE_PATH/jboss/container/util/logging/bash $EAP_MODULES/jboss/container/util/logging/bash

mkdir -p $EAP_MODULES/jboss/container/s2i/core/
cp -r $CCT_MODULE_PATH/jboss/container/s2i/core/bash $EAP_MODULES/jboss/container/s2i/core/bash

mkdir -p $EAP_MODULES/jboss/container/maven/default/
cp -r $CCT_MODULE_PATH/jboss/container/maven/default/bash $EAP_MODULES/jboss/container/maven/default/bash

mkdir -p $EAP_MODULES/jboss/container/eap/s2i/
cp -r $JBOSS_EAP_MODULES_PATH/jboss/container/eap/s2i/bash $EAP_MODULES/jboss/container/eap/s2i/bash

# java options
mkdir -p $EAP_MODULES/jboss/container/java/jvm/
cp -r $CCT_MODULE_PATH/jboss/container/java/jvm/bash $EAP_MODULES/jboss/container/java/jvm/bash

find $EAP_MODULES/ -type f -exec sed -i '' 's/jboss:root/1001:0/g' {} \;
