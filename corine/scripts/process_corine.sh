#!/bin/bash
# make directories to store the output data if they do not exist
mkdir -p /output_data/scripts

# logging
exec > >(tee -a /output_data/scripts/processing.log) 2>&1

# Start processing
echo "[$(date +%F\ %T)] Starting processing of CORINE land-cover data for the CAMELS-DE dataset..."

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

# Copy the output data to the camelsp output directory
echo "[$(date +%T)] Copying the extracted and postprocessed data to the camelsp output directory..."
mkdir -p /camelsp/output_data/raw_catchment_attributes/landcover/corine
cp -r /output_data/* /camelsp/output_data/raw_catchment_attributes/landcover/corine/
echo "[$(date +%T)] Copied the extracted and postprocessed data to the camelsp output directory"

# Change permissions of the output data
chmod -R 777 /camelsp/output_data/
chmod -R 777 /output_data/