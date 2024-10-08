#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"

# "If present the Geocode function can use it if a boundary filter is added to limit to just zips in that boundary. 
#  The Reverse_Geocode function uses it if the returned address is missing a zip, which often happens with highway reverse geocoding."
# https://postgis.net/docs/postgis_installation.html#install_tiger_geocoder_extension
# psql --dbname="$POSTGRES_DB" -c "UPDATE tiger.loader_lookuptables SET load = true WHERE table_name = 'zcta520';"
psql --dbname="$POSTGRES_DB" -c "SELECT Loader_Generate_Nation_Script('docker')" -tA > /gisdata/nation_script_load.sh
chmod u+x /gisdata/nation_script_load.sh
/gisdata/nation_script_load.sh
/gisdata/load-all-state-data.sh
