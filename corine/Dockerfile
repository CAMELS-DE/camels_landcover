# Pull python base image
FROM python:3.10

# Install R
RUN apt-get update && apt-get install -y r-base

# Install dependencies for camelsp with fixed versions
RUN pip install geopandas==0.14.3
RUN pip install "pandas<2.2.0"
RUN pip install numpy==1.25.2
RUN pip install matplotlib==3.8.3
RUN pip install plotly==5.19.0
RUN pip install pyproj==3.6.1
RUN pip install dateparser==1.2.0
RUN pip install dask==2024.2.0
RUN pip install ydata-profiling==4.6.4
RUN pip install tqdm==4.66.2
RUN pip install openpyxl==3.1.2
RUN pip install papermill==2.5.0
RUN pip install jupyter==1.0.0

# Install camelsp from GitHub
RUN git clone https://github.com/CAMELS-DE/camelsp.git
RUN pip install -e /camelsp

# Install R dependencies for corine
RUN apt-get install -y libudunits2-dev libgdal-dev libharfbuzz-dev libfribidi-dev
RUN R -e "install.packages('exactextractr')"
RUN R -e "install.packages('tidyverse')"

# Change working directory
WORKDIR /scripts

# Run sh script to process CORINE
CMD ["/bin/bash", "process_corine.sh"]