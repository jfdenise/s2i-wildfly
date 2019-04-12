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
cp -r $CCT_MODULE_PATH/jboss/container/maven/s2i/bash/artifacts/ $EAP_MODULES
cp -r $CCT_MODULE_PATH/jboss/container/util/logging/bash/artifacts/ $EAP_MODULES
cp -r $CCT_MODULE_PATH/jboss/container/s2i/core/bash/artifacts/ $EAP_MODULES
cp -r $CCT_MODULE_PATH/jboss/container/maven/default/bash/artifacts/ $EAP_MODULES
cp -r $JBOSS_EAP_MODULES_PATH/jboss/container/eap/s2i/bash/artifacts/ $EAP_MODULES

#customize with our own assemble and galleon scripts.
cp -r $DIRNAME/s2i/opt $EAP_MODULES
cp -r $DIRNAME/s2i/usr $EAP_MODULES

chmod -R a+x $EAP_MODULES/usr
