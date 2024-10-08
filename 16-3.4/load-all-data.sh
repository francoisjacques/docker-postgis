#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"
psql --dbname="$POSTGRES_DB" -c "UPDATE tiger.loader_lookuptables SET load = true WHERE process_order > 0;"
psql --dbname="$POSTGRES_DB" -c "SELECT Loader_Generate_Nation_Script('docker')" -tA > /gisdata/nation_script_load.sh
chmod u+x /gisdata/nation_script_load.sh
/gisdata/nation_script_load.sh
/gisdata/load-all-state-data.sh
