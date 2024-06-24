# CORINE Land Cover

## Description

Dockerized tool to extract and process data from the CORINE land cover tif file for CAMELS-DE.  
Implemented following the [tool-specs](https://vforwater.github.io/tool-specs/).  
A .csv file is created in the `output_data` folder containing the area percentage of land cover classes in each catchment. For CAMELS-DE we only use the superclasses of CORINE, the extracted variable are listed below.  

The created file `landcover_attributes.csv` is exactly structured as the `CAMELS_DE_landcover_attributes.csv` file in the CAMELS-DE dataset and therefor is directly compatible with CAMELS-DE.

## Container

### Build the container

```bash
docker build -t tbr_landcover_corine .
```

### Run the container

Follow the instructions in `input_data/README.md` to add the necessary input data to run the tool. 

To run the container, the local `in` and `out` directories have to be mounted inside the container:

```bash
docker run -it --rm -v ./in:/in -v ./out:/out -e TOOL_RUN=landcover_attributes_corine tbr_landcover_corine
```

## Output variables

All variables represent the area percentage of the main CORINE land cover classes of the total catchment area.  

**CORINE classes**:
- artificial_surfaces_perc [%]
- agricultural_areas_perc [%]
- forests_and_seminatural_areas_perc [%]
- wetlands_perc [%]
- water_bodies_perc [%]