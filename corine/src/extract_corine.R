# Calculate fractions of land use classes from CORINE dataset for catchment polygons (from gpkg).
# @author: Pia Ebeling, Alexander Dolich
#          and land use group of the CAMELS-DE team
#
# created: 2022/11/03
# modified: 2024/03/01

library(exactextractr)
library(terra)
library(sf)
library(foreign)

extract_corine_landcover <- function(corine, corine_dbf, catchments, id_field_name) {
  # Load corine raster
  print(paste("Loading CORINE raster from", corine, "..."))
  corine <- terra::rast(corine)

  # Match the CORINE classes with the .dbf
  print(paste("Loading CORINE classes from", corine_dbf, "..."))
  corine_classes <- foreign::read.dbf(corine_dbf)

  # Define the mapping from subclasses to main classes
  corine_mapping <- data.frame(
    subclass = corine_classes$Value,
    mainclass = as.numeric(as.character(corine_classes$CODE_18)) %/% 100  # Convert to numeric before division
  )

  # Define a function to reclassify the raster from subclasses to main classes
  print("Reclassifying the raster to main classes 1-5 (artificial_surfaces, agricultural_areas, forests_and_seminatural_areas, wetlands, water_bodies) ...")
  reclassify_raster <- function(x) {
    ifelse(is.na(x), NA, corine_mapping$mainclass[match(x, corine_mapping$subclass)])
  }

  # Apply reclassify the raster
  print("Applying reclassification to CORINE main classes ...")
  corine_main_classes <- terra::app(corine, reclassify_raster)

  # Load catchment polygons
  print(paste("Loading catchment polygons from", catchments, "..."))
  catchments <- sf::st_read(catchments)

  # transform catchments to match the raster coordinate system
  catchments <- sf::st_transform(catchments, sf::st_crs(corine_main_classes))

  # Extract the raster data for all catchments
  print("Extracting the raster data for all catchments ...")
  extracted_rast <- exactextractr::exact_extract(corine_main_classes, catchments,
                                                 fun = "frac", force_df = TRUE,
                                                 append_cols = id_field_name, progress = FALSE)

  # Convert fraction to percentage
  extracted_rast[, -1] <- extracted_rast[, -1] * 100

  # Add missing categories with zero coverage
  missing_categories <- setdiff(c("frac_1", "frac_2", "frac_3", "frac_4", "frac_5"), colnames(extracted_rast))
  for (category in missing_categories) {
    extracted_rast[[category]] <- 0.0  # Add a column with zero values
  }

  # round the percentages to 2 decimal places
  extracted_rast[, -1] <- round(extracted_rast[, -1], 2)

  # Define the names of the main classes
  main_class_names <- c("artificial_surfaces", "agricultural_areas", "forests_and_seminatural_areas", "wetlands", "water_bodies")

  # Rename the columns
  colnames(extracted_rast)[-1] <- paste(main_class_names, "perc", sep = "_")
  colnames(extracted_rast)[1] <- "gauge_id" # camels_de: always gauge_id

  # Save the extracted data
  print("Saving the extracted data to /out/corine_extracted.csv ...")
  write.csv(extracted_rast, "/out/corine_extracted.csv", row.names = FALSE)
}

# set user permissions for the output directory
system("chmod -R 777 /out/")