SHELL := /bin/bash
TOWN_GEOJSON_URL = https://opendata.arcgis.com/datasets/0e4a5d2d58ac40bf87cd8aa950138ae8_39.geojson
CENSUS_2019_URL = https://www.healthvermont.gov/sites/default/files/documents/xls/HS-STAT-Population-of-Vermont-towns-1930-2019.xls
DBNAME=vt_migration

# NB - 1880 census data transcribed
# from https://vermonthistory.org/client_media/files/Learn/Census%20Records/1880-Census.pdf

.PHONY : download_towns download_census_data migratedb initdb dropdb cleandb

download_towns :
	mkdir -p data/vcgi
	curl -s $(TOWN_GEOJSON_URL) --output data/vcgi/towns.geojson

download_census_data :
	mkdir -p data/vthealth
	curl -s $(CENSUS_2019_URL) --output data/vthealth/pop2019.xls
	in2csv --no-header-row data/vthealth/pop2019.xls | csvcut -c b,ddd | csvformat -K5 > data/vthealth/pop2019.csv

# database commands
migratedb :
	flyway -configFiles=flyway.conf -user=$(USER) migrate

initdb :
	createdb $(DBNAME)
	psql -d $(DBNAME) -c "CREATE EXTENSION postgis;"

dropdb :
	dropdb --if-exists $(DBNAME)

cleandb : dropdb initdb migratedb

import_pop :
	psql -d $(DBNAME) -c 'COPY historical_pop(name, pop, year)
                           FROM 'C:\sampledb\persons.csv'
                           DELIMITER ','
                           CSV HEADER;'
