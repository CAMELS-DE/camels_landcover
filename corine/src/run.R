# load json2aRgs for parameter parsing
library(json2aRgs)

# load the extract_corine function
source("extract_corine.R")

# get the parameters for the tool
params <- get_parameters()

# get the data paths for the tool
data <- get_data(return_data_paths = TRUE)

# check if a toolname was set in env
toolname <- tolower(Sys.getenv("TOOL_RUN"))

# if no toolname was set, stop the script
if (toolname == "") {
  stop("No toolname was set in the environment. Please set the TOOL_RUN environment variable.")

} else if (toolname == "landcover_attributes_corine") {
  extract_corine_landcover(corine = data$corine_tif,
                           corine_dbf = data$corine_dbf,
                           catchments = data$catchments,
                           id_field_name = params$id_field_name)

} else {
  stop("The toolname '", toolname, "' is not supported.")
}
