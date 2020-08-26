#!/bin/zsh

# (c) Sabin Zahirovic, 4 October 2019

# Instructions

# Choose your longitude (lon) to be somewhat in the centre of your longitudinal range
# Choose your initial latitude (lat) to be the southernmost part of your domain
# Change the density value to represent degrees along a great circle
# Change your maximum latitude, which will be iterated over

# Note: This script uses the Z shell 


lon=132 # Reference point
lat=-45 # Reference point
max_lat=-2
distance=24 # degrees along a great circle
azimuth=90 # azimuth, clockwise from north relative to reference point

target_resolution=10 # km

pi=3.14159265359
radius=6371

# arc_length=$( echo  " 2 * $pi * $radius * ( $density / 360 ) "  | bc -l ) # degrees to km
 
density=$( echo "( ${target_resolution} / ( 2 * $pi * $radius) ) * 360" | bc -l )
echo $density
# density=0.1 # degrees along a great circle



paleo_topo_grid=/Users/sabinz/Documents/Research/Paleogeography/BGH_PGEO_with_Elevation_Union_Australia_Extent/SmoothedRasters/ptopo_smoothed_F17Call_160_union_g150.nc 

filename_lon_lat=${lon}_${lat}

rm mesh_${target_resolution}km.gmt
row=0

echo " Arc length is ${density} degrees "


while (( $lat <= $max_lat ))
do

	echo "Co-ordinate being used is " $lon ", " $lat " (LON, LAT) and azimuth of" $prof_azimuth "with a distance of " $distance " degrees"
		
	gmt project -C${lon}/${lat} -A${azimuth} -L-${distance}/${distance} -G${density} -V -fg > tmp.dat

	awk -v row=$row '{ print $1, $2, row, NR-1 }' tmp.dat >> mesh_${target_resolution}km.gmt


row=$(( $row + 1 ))
lat=$(( $lat + $density ))
done

# Sampling grid 
# Make sure grid is large enough to capture all mesh nodes
gmt grdtrack mesh_${target_resolution}km.gmt -G${paleo_topo_grid} -di-9000 > mesh_and_elevation_${target_resolution}km.gmt

echo "lon,lat,row,column,elevation,point_no" > ShapefileInput_badlands_mesh_LonLat_${filename_lon_lat}_MaxLat_${max_lat}_Azimuth_${azimuth}_GCDistance_${distance}_Resolution_${target_resolution}km.csv

awk 'BEGIN{OFS=","} { print $1, $2, $3, $4, int($5), NR }' mesh_and_elevation_${target_resolution}km.gmt >> ShapefileInput_badlands_mesh_LonLat_${filename_lon_lat}_MaxLat_${max_lat}_Azimuth_${azimuth}_GCDistance_${distance}_Resolution_${target_resolution}km.csv

# Turning into regular grid
# awk -v resolution=${target_resolution} '{printf "%.1f %.1f %.1f\n",$3*resolution*1000, $4*resolution*1000, int($5) }' mesh_and_elevation_${target_resolution}km.gmt > badlands_mesh_LonLat_${filename_lon_lat}_Resolution_${target_resolution}km.csv
awk -v resolution=${target_resolution} '{printf "%.1f %.1f %.1f\n", $4*resolution*1000, $3*resolution*1000, $5 }' mesh_and_elevation_${target_resolution}km.gmt > badlands_mesh_LonLat_${filename_lon_lat}_MaxLat_${max_lat}_Azimuth_${azimuth}_GCDistance_${distance}_Resolution_${target_resolution}km.csv