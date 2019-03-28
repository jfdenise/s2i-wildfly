#!/bin/sh

# mysql db container must be linked w/ alias "mysql"
if [ -n "$MYSQL_DATABASE" ]
then
  export CLI_CONFIG_CONTENT=$CLI_CONFIG_CONTENT"/subsystem=datasources/data-source=MySQLDS:write-attribute(name=enabled,value=true)"$'\n'
fi