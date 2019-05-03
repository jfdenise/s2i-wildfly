#!/bin/sh
# Openshift WildFly launch script

source $JBOSS_HOME/bin/launch/logging.sh

# TERM signal handler
function clean_shutdown() {
  log_error "*** WildFly wrapper process ($$) received TERM signal ***"
  $JBOSS_HOME/bin/jboss-cli.sh -c "shutdown --timeout=60"
  wait $!
}


log_info "Running $IMAGE_NAME image, version $IMAGE_VERSION"

trap "clean_shutdown" TERM
trap "clean_shutdown" INT

if [ -n "$CLI_GRACEFUL_SHUTDOWN" ] ; then
  trap "" TERM
  log_info "Using CLI Graceful Shutdown instead of TERM signal"
fi


$JBOSS_HOME/bin/standalone.sh -c $SERVER_CONFIGURATION -b 0.0.0.0 -bmanagement 0.0.0.0 -Dwildfly.statistics-enabled=true &

PID=$!
wait $PID 2>/dev/null
wait $PID 2>/dev/null
