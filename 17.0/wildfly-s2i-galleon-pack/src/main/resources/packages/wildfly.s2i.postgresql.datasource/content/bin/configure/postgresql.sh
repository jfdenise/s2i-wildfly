#!/bin/sh

# postgresql db container must be linked w/ alias "postgresql"

if [ -n "$POSTGRESQL_DATABASE" ]
then
  export CLI_CONFIG_CONTENT=$CLI_CONFIG_CONTENT"/subsystem=datasources/data-source=PostgreSQLDS:write-attribute(name=enabled,value=true)"$'\n' 
fi