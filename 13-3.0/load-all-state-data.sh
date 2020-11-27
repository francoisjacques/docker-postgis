#!/bin/sh
# Load PostGIS into both template_database and $POSTGRES_DB
for STATE in AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MI MN MO MP MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UT VA VI VT WA WI WV WY; do
    echo "Updating PostGIS loader data..."
    psql --dbname="$POSTGRES_DB" -c "SELECT Loader_Generate_Script(ARRAY['${STATE}'], 'docker')" -tA > /gisdata/${STATE}_load.sh
    sh ${STATE}_load.sh
done
