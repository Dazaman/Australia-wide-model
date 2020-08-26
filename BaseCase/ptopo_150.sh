#!/bin/bash
#Project: Converting paleogeography grid into paleotopography
#Date: 26/07/2017
#Author: Carmen Braz


## Input files ---------

version=BaseCase
paleotopo=Paleotopo/Input/Paleotopo_${version}.shp


# xy files
# resol="_5km_xy"
# resol="_25km"
resol="_50km"

input_latlon=LatLon${resol}.xy
input_utm=UTM${resol}.xy

region=82/179.9/-55/10

## Output files -----------

# Converted to gmt file
out_gmt=Paleotopo_${version}.gmt
# Paleotopography converted to grid
ptopo_grid=ptopo_${version}.nc

# Smoothing factor - increase from 3 for higher resolution models
g_filter=3
# Smoothed grid
smooth_grid=Paleotopo_g${g_filter}${resol}.nc

# grdtrack output 
latlon_csv=Paleotopo_150Ma_latlon_g${g_filter}${resol}

ogr2ogr -f "GMT" ${out_gmt} ${paleotopo}

gmt grdmask ${out_gmt} -R${region} -I0.25 -Nz -aZ=ELEVATION -V -G${ptopo_grid}


gmt grdfilter ${ptopo_grid} -G${smooth_grid} -D0 -I0.25 -V -Fg${g_filter}


gmt grdtrack -G${smooth_grid} ${input_latlon} -V > ${latlon_csv}_${version}.csv


paste ${input_utm} ${latlon_csv}_${version}.csv | awk -F" " '{ print $1 " " $2 " " $5 }' > Paleotopo_${version}.csv

# Might need to use dos2unix on input utm and latlon

# To change precision of output files for 5km resolution model
awk -F" " '{ printf("%.2f,%.2f,%.2f\n",$1,$2,$3)}' Paleotopo_${version}.csv > temp.csv
awk -F"," '{ print $1 " " $2 " " $3 }' temp.csv > Paleotopo/Output/Paleotopo_${version}${resol}.csv

cp Paleotopo/Output/Paleotopo_${version}${resol}.csv /Parameters_maps${resol}/Paleotopo/Paleotopo_${version}${resol}.csv

rm *Paleotopo*.csv
rm temp.csv
rm *.nc
rm *.gmt