#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"
psql --dbname="$POSTGRES_DB" -c "SELECT Loader_Generate_Nation_Script('docker')" -tA > /gisdata/nation_script_load.sh
cd /gisdata
sh nation_script_load.sh

sh load-all-state-data.sh