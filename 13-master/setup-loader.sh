#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
    echo "Updating PostGIS loader data..."
    psql --dbname="$DB" -c "
        -- Upgrade PostGIS (includes raster)
        INSERT INTO tiger.loader_platform (os, declare_sect, pgbin, wget, unzip_command, psql, path_sep, loader, environ_set_command, county_process_command) VALUES ('docker', 'TMPDIR=\"\${staging_fold}/temp/\"
        UNZIPTOOL=unzip
        WGETTOOL=\"/usr/bin/wget\"
        export PGBIN=/usr/lib/postgresql/13/bin
        export PGPORT=5432
        export PGHOST=localhost
        export PGUSER=${POSTGRES_USER}
        export PGPASSWORD=${POSTGRES_PASSWORD}
        export PGDATABASE=${POSTGRES_DB}
        PSQL=\${PGBIN}/psql
        SHP2PGSQL=shp2pgsql
        cd \${staging_fold}
        ', '', 'wget --no-check-certificate', 'rm -f \${TMPDIR}/*.*
        \${PSQL} -c \"DROP SCHEMA IF EXISTS \${staging_schema} CASCADE;\"
        \${PSQL} -c \"CREATE SCHEMA \${staging_schema};\"
        for z in *.zip; do \$UNZIPTOOL -o -d \$TMPDIR \$z; done
        cd \$TMPDIR;
        ', '\${PSQL}', '/', '\${SHP2PGSQL}', 'export ', 'for z in *\${table_name}*.dbf; do
        \${loader} -D -s 4269 -g the_geom -W \"latin1\" \$z \${staging_schema}.\${state_abbrev}_\${table_name} | \${psql}
        \${PSQL} -c \"SELECT loader_load_staged_data(lower(''\${state_abbrev}_\${table_name}''), lower(''\${state_abbrev}_\${lookup_name}''));\"
        done');
    "

done
