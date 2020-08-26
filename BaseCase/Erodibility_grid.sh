#!/bin/bash
#Project: Converting erodibility polygons into erodibility grid
## Two sections, one with variable Erodibility across Tasman Line, 
## the other including a higher erodibility polygon for the eastern volcanic arc/cordillera

version="BaseCase"
## Erodibility shapefile 1 name - includes zealandia arc/cordillera
erod="Erodibility_CordArc_"${version}

# resol="_5km_xy"
resol="_50km"
# resol="_25km"

input_latlon=LatLon${resol}.xy

# Convert shp file to gmt
ogr2ogr -f "GMT" ${erod}.gmt Erodibility/Input/${erod}.shp

# # Grd mask to grid the gmt files
gmt grdmask ${erod}.gmt -Rd -I0.2 -NZ -aZ=Erod -V -G${erod}.nc

### Smoothing factor
g_filter=2
#
smooth_grid=erod_g${g_filter}${resol}.nc

gmt grdfilter ${erod}.nc -G${smooth_grid} -D0 -I0.2 -V -Fg${g_filter}

# # Produces csv
# gmt grdtrack -G${erod}.nc $input_latlon -V > ${erod}.csv
gmt grdtrack -G${smooth_grid} $input_latlon -V > ${erod}.csv

# # Change lat lon values to utm values for Badlands
awk -F" " '{ print $3 }' ${erod}.csv > ${erod}_utm.csv

awk -F"e-" '{ printf("%.0f\n",$1)}' ${erod}_utm.csv > temp.csv

awk -F"e-" '{ print "e-" $2 }' ${erod}_utm.csv > temp2.csv											

paste temp.csv temp2.csv | awk -F" " '{print $1 $2}' > Erodibility/Output/${erod}${resol}.csv

cp Erodibility/Output/${erod}${resol}.csv Parameters_maps${resol}/Erodibility/${erod}${resol}.csv

rm ${erod}*.csv
rm temp*.csv
rm *.nc
rm *.gmt

## Erodibility shapefile 2 name 
erod="Erodibility_TasLine_"${version}

# resol="_5km_xy"
# resol="_50km"
# resol="_25km"

# Convert shp file to gmt
ogr2ogr -f "GMT" ${erod}.gmt Erodibility/Input/${erod}.shp

# # Grd mask to grid the gmt files
gmt grdmask ${erod}.gmt -Rd -I0.1 -NZ -aZ=Erod -V -G${erod}.nc

### Smoothing factor
g_filter=2
#
smooth_grid=erod_g${g_filter}${resol}.nc

gmt grdfilter ${erod}.nc -G${smooth_grid} -D0 -I0.2 -V -Fg${g_filter}

# # Produces csv
# gmt grdtrack -G${erod}.nc $input_latlon -V > ${erod}.csv
gmt grdtrack -G${smooth_grid} $input_latlon -V > ${erod}.csv


# # Change lat lon values to utm values for Badlands
awk -F" " '{ print $3 }' ${erod}.csv > ${erod}_utm.csv

awk -F"e-" '{ printf("%.0f\n",$1)}' ${erod}_utm.csv > temp.csv

awk -F"e-" '{ print "e-" $2 }' ${erod}_utm.csv > temp2.csv											


paste temp.csv temp2.csv | awk -F" " '{print $1 $2}' > Erodibility/Output/${erod}${resol}.csv


cp Erodibility/Output/${erod}${resol}.csv Parameters_maps${resol}/Erodibility/${erod}${resol}.csv

rm ${erod}*.csv
rm temp*.csv
rm *.nc
rm *.gmt