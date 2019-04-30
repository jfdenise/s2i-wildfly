#!/bin/bash
DIRNAME=`dirname "$0"`
export RUN_CONF=$DIRNAME/default_configure.sh
. $DIRNAME/standalone.sh
