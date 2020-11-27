FROM postgres:13

LABEL maintainer="PostGIS Project - https://postgis.net"

ENV POSTGIS_MAJOR "3"
ENV POSTGIS_VERSION "3.0.3+dfsg-2.pgdg100+1"

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           postgis \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
           wget unzip \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d && mkdir -p /gisdata && mkdir -p /gisdata/temp && chown -R postgres:postgres /gisdata
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./setup-loader.sh /docker-entrypoint-initdb.d/11_postgis.sh
COPY ./load-all-data.sh /gisdata/load-all-data.sh
COPY ./load-default-data.sh /gisdata/load-default-data.sh
COPY ./update-postgis.sh /usr/local/bin

EXPOSE 5432