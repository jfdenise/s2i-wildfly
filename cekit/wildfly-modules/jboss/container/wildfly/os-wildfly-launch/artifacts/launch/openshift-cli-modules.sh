#!/bin/sh
# Common Openshift WildFly scripts

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

SERVER_CONFIG=${WILDFLY_SERVER_CONFIGURATION:-standalone.xml}
CONFIG_FILE=$JBOSS_HOME/standalone/configuration/${SERVER_CONFIG}
LOGGING_FILE=$JBOSS_HOME/standalone/configuration/logging.properties

CONFIGURE_CLI_SCRIPTS=(
)

if [ -f $JBOSS_HOME/bin/launch/mysql.sh ]; then
    CONFIGURE_CLI_SCRIPTS+=($JBOSS_HOME/bin/launch/mysql.sh)
fi

if [ -f $JBOSS_HOME/bin/launch/postgresql.sh ]; then
    CONFIGURE_CLI_SCRIPTS+=($JBOSS_HOME/bin/launch/postgresql.sh)
fi

if [ -f $JBOSS_HOME/bin/launch/datasource.sh ]; then
    CONFIGURE_CLI_SCRIPTS+=($JBOSS_HOME/bin/launch/datasource.sh)
fi