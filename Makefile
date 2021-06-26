SHELL := /bin/bash
TOWN_GEOJSON_URL = https://opendata.arcgis.com/datasets/0e4a5d2d58ac40bf87cd8aa950138ae8_39.geojson

# NB - 1880 census data transcribed 
# from https://vermonthistory.org/client_media/files/Learn/Census%20Records/1880-Census.pdf

.PHONY : download_towns 

download_towns :
	mkdir -p data/vcgi
	curl -s $(TOWN_GEOJSON_URL) --output data/vcgi/towns.geojson

