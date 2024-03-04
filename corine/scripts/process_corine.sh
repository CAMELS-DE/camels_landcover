#!/bin/bash
# make directories to store the output data if they do not exist
mkdir -p /output_data/scripts

# logging
exec > >(tee -a /output_data/scripts/processing.log) 2>&1

# Generate catchments geopackage
echo "[$(date +%T)] Generating MERIT Hydro catchments geopackage..."
python /scripts/01_generate_catchments_gpkg.py
cp /scripts/01_generate_catchments_gpkg.py /output_data/scripts/01_generate_catchments_gpkg.py
echo "[$(date +%T)] Saved MERIT Hydro geopackage for all CAMELS-DE stations with 01_generate_catchments_gpkg.py"

# Extract CORINE data
echo "[$(date +%T)] Extracting CORINE data..."
Rscript /scripts/02_extract_corine.R
cp /scripts/02_extract_corine.R /output_data/scripts/02_extract_corine.R
echo "[$(date +%T)] Saved extracted CORINE data for all CAMELS-DE stations with 02_extract_corine.R"

# Save the extracted CORINE data to camelsp stations
python /scripts/03_save_corine_to_stations.py
cp /scripts/03_save_corine_to_stations.py /output_data/scripts/03_save_corine_to_stations.py
echo "[$(date +%T)] Saved extracted CORINE data to CAMELS-DE stations with 03_save_corine_to_stations.py"

# Change permissions of the output data
chmod -R 777 /camelsp/output_data/
chmod -R 777 /output_data/