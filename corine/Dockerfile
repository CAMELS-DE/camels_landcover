# Pull python base image, as base:R does not compile gdal
FROM python:3.10

# Install R
RUN apt-get update && apt-get install -y r-base

# the parameter parsing function always needs the rjson and yaml packages
RUN R -e "install.packages(c('jsonlite', 'yaml'))"

# install remotes to install latest version of json2aRgs from Github
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('VForWaTer/json2aRgs')"

# install json2aRgs v0.3.0 to parse parameters from /in/parameters.json
# RUN wget -q https://cran.r-project.org/src/contrib/json2aRgs_0.3.0.tar.gz
# RUN R CMD INSTALL json2aRgs_0.3.0.tar.gz

# # remove json2aRgs tarball
# RUN rm json2aRgs_0.3.0.tar.gz

# Install R dependencies for corine
RUN apt-get install -y libudunits2-dev libgdal-dev libharfbuzz-dev libfribidi-dev
RUN R -e "install.packages('exactextractr')"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

# Run tools
WORKDIR /src
CMD ["Rscript", "run.R"]