# camels_landuse
Repository to process land-use data for CAMELS-DE.

## CORINE Land Cover

### 1. Download CORINE dataset

Login and download `CORINE Land Cover 2018 (vector/raster 100 m), Europe, 6-yearly` from COPERNICUS.  
When the download is ready unzip everything and only place the `.tif` and the `.dbf` in the `input_data` folder:
- `U2018_CLC2018_V2020_20u1.tif`
- `U2018_CLC2018_V2020_20u1.tif.vat.dbf`  

citation for the dataset: https://doi.org/10.2909/960998c1-1870-4e82-8051-6485205ebbac

Run:
`docker run -v ./input_data:/input_data -v ./output_data:/output_data -v ./scripts:/scripts -v /path/to/camelsp/output_data:/camelsp/output_data -it --rm corine`