#!/bin/bash
DIRNAME=`dirname "$0"`
if [ ! -f $DIRNAME/jboss-cli.sh ]; then
    echo CLI not installed, runtime scripts will be not applied, returning
    return 0
fi

export CLI_CONFIG_CONTENT=""
if [ -f $DIRNAME/launch/mysql.sh ]; then
 . $DIRNAME/launch/mysql.sh
fi
if [ -f $DIRNAME/launch/postgresql.sh ]; then
 . $DIRNAME/launch/postgresql.sh
fi
if [ ! -z "$CLI_CONFIG_CONTENT" ]; then
echo Applying custom configuration [$CLI_CONFIG_CONTENT]

systime=`date +%s`
cat <<EOF > /tmp/cli-script-${systime}.sh
embed-server
$CLI_CONFIG_CONTENT
stop-embedded-server
EOF

$DIRNAME/jboss-cli.sh --file=/tmp/cli-script-${systime}.sh
ret=$?
rm /tmp/cli-script-${systime}.sh
if [ $ret -ne 0 ]; then
  echo "Warning, error appling CLI script"
  return 1
fi
fi

