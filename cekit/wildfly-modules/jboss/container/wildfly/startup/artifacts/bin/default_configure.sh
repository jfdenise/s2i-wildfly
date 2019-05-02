#!/bin/bash
export OPENSHIFT_HOSTNAME=$HOSTNAME

max_threads=$(ulimit -u)

if ! [[ "$max_threads" =~ ^[0-9]+$ ]] ; then
        max_threads=1024
fi

# if [ -z "$MESSAGING_THREAD_RATIO" ]; then
#     MESSAGING_THREAD_RATIO=0.2
# fi

# default to 512meg of total container memory (heap will be a percentage of this value)
max_memory_mb=512
# use historical OPENSHIFT_GEAR_MEMORY_MB for container memory size, if specified
if [ -n "$OPENSHIFT_GEAR_MEMORY_MB" ]; then
  max_memory_mb=$OPENSHIFT_GEAR_MEMORY_MB
# otherwise try to set the container memory size based on the cgroup limits
else
  CONTAINER_MEMORY_IN_BYTES=`cat /sys/fs/cgroup/memory/memory.limit_in_bytes`
  DEFAULT_MEMORY_CEILING=$((2**40-1))
  if [ "${CONTAINER_MEMORY_IN_BYTES}" -lt "${DEFAULT_MEMORY_CEILING}" ]; then
      max_memory_mb=$((${CONTAINER_MEMORY_IN_BYTES}/1024**2))
  fi 
fi
if [ -z "$JVM_HEAP_RATIO" ]; then
    JVM_HEAP_RATIO=0.5
fi
max_heap=$( echo "$max_memory_mb * $JVM_HEAP_RATIO" | bc | awk '{print int($1+0.5)}')

# messaging_thread_pool_max_size=$( echo "$max_threads * $MESSAGING_THREAD_RATIO" | bc | awk '{print int($1+0.5)}')
# messaging_scheduled_thread_pool_max_size=5
# $( echo "$max_threads * $MESSAGING_THREAD_RATIO" | bc | awk '{print int($1+0.5)}')

if [ $max_heap -lt 1024 ]
then
    memory_options="-XX:+UseParallelGC -Xms40m -Xmx${max_heap}m -XX:+AggressiveOpts -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dorg.apache.tomcat.util.LOW_MEMORY=true" 
else
    memory_options="-XX:+UseParallelGC -Xms40m -Xmx${max_heap}m -XX:+AggressiveOpts -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90"
fi

if [ -z "${OPENSHIFT_WILDFLY_CLUSTER_PROXY_PORT}" ]; then
    export OPENSHIFT_WILDFLY_CLUSTER_PROXY_PORT=7600
fi

if [ -z "${OPENSHIFT_WILDFLY_CLUSTER}" ]; then
    export OPENSHIFT_WILDFLY_CLUSTER="${OPENSHIFT_JBOSSEAP_IP}[${OPENSHIFT_JBOSSEAP_CLUSTER_PORT}]"
fi

#
# Specify options to pass to the Java VM.
#

if [ "x$JBOSS_MODULES_SYSTEM_PKGS" = "x" ]; then
   JBOSS_MODULES_SYSTEM_PKGS="org.jboss.byteman"
fi

if [ -z "$JAVA_OPTS" ]; then
   JAVA_OPTS="$memory_options -DOPENSHIFT_APP_UUID=${OPENSHIFT_APP_UUID} -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS -Djava.awt.headless=true -Dorg.jboss.resolver.warning=true -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8 -Djboss.node.name=${OPENSHIFT_HOSTNAME} -Djgroups.bind_addr=0.0.0.0 -Dorg.apache.coyote.http11.Http11Protocol.COMPRESSION=on"
   if [ ! -z "$ENABLE_JPDA" ]; then
      JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:8787,server=y,suspend=n ${JAVA_OPTS}"
   fi
fi

if [ -n "$JAVA_OPTS_EXT" ]; then
    JAVA_OPTS="$JAVA_OPTS $JAVA_OPTS_EXT"
fi

export JBOSS_MODULEPATH=$JBOSS_HOME/modules

if [ ! -z $OPENSHIFT_WILDFLY_MODULE_PATH ]; then
   export JBOSS_MODULEPATH=$JBOSS_MODULEPATH:$OPENSHIFT_WILDFLY_MODULE_PATH
fi

export JAVA_OPTS




