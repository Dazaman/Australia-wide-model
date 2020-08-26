#!/bin/bash
#Project: Converting erodibility polygons into erodibility grid
## Two sections, one with variable Erodibility across Tasman Line, 
## the other including a higher erodibility polygon for the eastern volcanic arc/cordillera

## Version name defined in input csv
version="BaseCase"

## Two layers - prefix defined in xml generation script
ErodLayer1="Erodibility_CordArc_"${version}
ErodLayer2="Erodibility_TasLine_"${version}

mkdir Output

## Erodibility shapefile 1 name - includes zealandia arc/cordillera
erod_input=Input/${ErodLayer1}

# resol="_5km_xy"
# resol="_50km"
# resol="_25km"
resol="_50km_GDA94"

input_latlon=../LatLon${resol}.xy

# Convert shp file to gmt
ogr2ogr -f "GMT" ${ErodLayer1}.gmt ${erod_input}.shp

# Grdmask to convert gmt to grid file
gmt grdmask ${ErodLayer1}.gmt -Rd -I0.2 -NZ -aZ=Erod -V -G${ErodLayer1}.nc

### Smoothing factor
g_filter=2

smooth_grid=erod_g${g_filter}${resol}.nc
gmt grdfilter ${ErodLayer1}.nc -G${smooth_grid} -D0 -I0.2 -V -Fg${g_filter}


# Produces csv
gmt grdtrack -G${smooth_grid} $input_latlon -V > ${ErodLayer1}.csv

# Change lat lon values to utm values for Badlands
awk -F" " '{ print $3 }' ${ErodLayer1}.csv > ${ErodLayer1}_utm.csv

awk -F"e-" '{ printf("%.0f\n",$1)}' ${ErodLayer1}_utm.csv > temp.csv

awk -F"e-" '{ print "e-" $2 }' ${ErodLayer1}_utm.csv > temp2.csv											


paste temp.csv temp2.csv | awk -F" " '{print $1 $2}' > Output/${ErodLayer1}${resol}.csv

# Create uniform erodibility grid for top layer
# awk -F"e-" '{ print $1=8 "e-" $2 }' new_${erod}${resol}.csv > new_uniform_${erod}${resol}.csv

cp Output/${ErodLayer1}${resol}.csv ../Parameters_maps${resol}/Erodibility/${ErodLayer1}${resol}.csv

## Remove all temporary pre-processing files
rm temp.csv
rm temp2.csv
rm ${ErodLayer1}_utm.csv
rm ${ErodLayer1}.csv
rm ${ErodLayer1}_utm.csv
rm ${ErodLayer1}.nc
rm ${smooth_grid}
rm ${ErodLayer1}.gmt

### ------------------------------------------
### Repeat process for Tas Line shapefile - name defined above
## Erodibility shapefile 2 input
erod_input=Input/${ErodLayer2}

# Convert shp file to gmt
ogr2ogr -f "GMT" ${ErodLayer2}.gmt ${erod_input}.shp

# # Grd mask to grid the gmt files
gmt grdmask ${ErodLayer2}.gmt -Rd -I0.1 -NZ -aZ=Erod -V -G${ErodLayer2}.nc

### Smoothing factor
g_filter=2
smooth_grid=erod_g${g_filter}${resol}.nc

gmt grdfilter ${ErodLayer2}.nc -G${smooth_grid} -D0 -I0.2 -V -Fg${g_filter}

# # Produces csv
# gmt grdtrack -G${erod}.nc $input_latlon -V > ${erod}.csv
gmt grdtrack -G${smooth_grid} $input_latlon -V > ${ErodLayer2}.csv


# # Change lat lon values to utm values for Badlands
awk -F" " '{ print $3 }' ${ErodLayer2}.csv > ${ErodLayer2}_utm.csv

awk -F"e-" '{ printf("%.0f\n",$1)}' ${ErodLayer2}_utm.csv > temp.csv

awk -F"e-" '{ print "e-" $2 }' ${ErodLayer2}_utm.csv > temp2.csv											

paste temp.csv temp2.csv | awk -F" " '{print $1 $2}' > Output/${ErodLayer2}${resol}.csv

# Create uniform erodibility grid for top layer
# awk -F"e-" '{ print $1=8 "e-" $2 }' new_${erod}${resol}.csv > new_uniform_${erod}${resol}.csv

cp Output/${ErodLayer2}${resol}.csv ../Parameters_maps${resol}/Erodibility/${ErodLayer2}${resol}.csv

rm temp.csv
rm temp2.csv
rm ${ErodLayer2}_utm.csv
rm ${ErodLayer2}.csv
rm ${ErodLayer2}_utm.csv
rm ${ErodLayer2}.nc
rm ${smooth_grid}
rm ${ErodLayer2}.gmt