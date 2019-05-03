#!/bin/sh

function configure() {
 if [ -n "$POSTGRESQL_DATABASE" ]
 then
  cat <<'EOF' >> ${CLI_SCRIPT_FILE}
      if (outcome == success) of /subsystem=datasources/data-source=PostgreSQLDS:read-resource
        /subsystem=datasources/data-source=PostgreSQLDS:write-attribute(name=enabled,value=true)
      end-if
EOF
 fi
}