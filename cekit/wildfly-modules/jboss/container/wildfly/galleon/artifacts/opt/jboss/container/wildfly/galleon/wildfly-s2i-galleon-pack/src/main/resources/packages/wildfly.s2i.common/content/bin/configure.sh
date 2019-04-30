#!/bin/bash
DIRNAME=`dirname "$0"`
export CLI_CONFIG_CONTENT=""
if [ -f $DIRNAME/configure/mysql.sh ]; then
 . $DIRNAME/configure/mysql.sh
fi
if [ -f $DIRNAME/configure/postgresql.sh ]; then
 . $DIRNAME/configure/postgresql.sh
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

