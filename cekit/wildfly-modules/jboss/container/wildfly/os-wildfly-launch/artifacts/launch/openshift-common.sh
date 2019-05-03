#!/bin/sh
# Common Openshift WildFly scripts

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

CONFIG_FILE=$JBOSS_HOME/standalone/configuration/${SERVER_CONFIGURATION}
LOGGING_FILE=$JBOSS_HOME/standalone/configuration/logging.properties

CONFIGURE_SCRIPTS=(
  # TODO $JBOSS_HOME/bin/launch/datasource.sh
  # TODO, add some more scripts.
  /opt/run-java/proxy-options
)

if [ -x $JBOSS_HOME/bin/launch/mysql.sh ]; then
    CONFIGURE_SCRIPTS+=($JBOSS_HOME/bin/launch/mysql.sh)
fi

if [ -x $JBOSS_HOME/bin/launch/postgresql.sh ]; then
    CONFIGURE_SCRIPTS+=($JBOSS_HOME/bin/launch/postgresql.sh)
fi