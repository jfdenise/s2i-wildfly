#!/bin/sh

function configure() {
 if [ -n "$MYSQL_DATABASE" ]
 then
  cat <<'EOF' >> ${CLI_SCRIPT_FILE}
      if (outcome == success) of /subsystem=datasources/data-source=MySQLDS:read-resource
        /subsystem=datasources/data-source=MySQLDS:write-attribute(name=enabled,value=true)
      end-if
EOF
 fi
}