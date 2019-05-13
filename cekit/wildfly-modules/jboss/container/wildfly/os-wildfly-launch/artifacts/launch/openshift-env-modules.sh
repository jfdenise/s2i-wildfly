#!/bin/sh
# Common Openshift WildFly scripts

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

SERVER_CONFIG=${WILDFLY_SERVER_CONFIGURATION:-standalone.xml}
CONFIG_FILE=$JBOSS_HOME/standalone/configuration/${SERVER_CONFIG}
LOGGING_FILE=$JBOSS_HOME/standalone/configuration/logging.properties

CONFIGURE_ENV_SCRIPTS=(
)

if [ -f /opt/run-java/proxy-options ]; then
    CONFIGURE_ENV_SCRIPTS+=(/opt/run-java/proxy-options)
fi

if [ -f $JBOSS_HOME/bin/launch/jboss_modules_system_pkgs.sh ]; then
    CONFIGURE_ENV_SCRIPTS+=($JBOSS_HOME/bin/launch/jboss_modules_system_pkgs.sh)
fi