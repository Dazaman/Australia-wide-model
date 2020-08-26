#!/bin/bash
#

### Rotate and calculate dynamic topography change between timesteps and add uplift from shapefiles to each timestep

### ----- Variables ----------------------------

### Dynamic topography folder location
dt_root=/home/danial/Badlands_workflow/Badlands_workflow/Dynamic_Topography

# Badlands model name
badlands_model_run=$1
batch=$5
echo "batch is" $batch

dt_model=$2
model_type="MantleFrame"
water=""
Res="HiRes"
grid_type="nc"

## Guassian filter factor
g_filter=2

## Final csv resolution
# resol=""
# resol="_5km_xy"
resol="_"$3

## Grid region - resample grids to same dimension and resolution, smaller region reduces runtime 
region=82/179.9/-55/12

# When not scaling dytopo, make these variables = ""
scale="_Scaled"
scale_factor=$4
scaled="Scaled_"${dt_model}"_"${scale_factor}"/"
s_dt="_"${scale_factor}

# scale=""
# scale_factor=""
# scaled=""
# s_dt=""


## Values need to be adjusted to match the resolution of the dynamic topography grids -----
## 3601 x 1801 = 0.1
## 1441 x 721 = 0.25
gmath_res="0.1"
gfilter_res="0.1"


### ----- Make all directories ------------------------------------

# For dynamic topography
mkdir ${dt_root}/${dt_model}_output/${scaled}Change_grid
mkdir ${dt_root}/${dt_model}_output/${scaled}Change_grid_originals
mkdir ${batch}/${badlands_model_run} ## Badlands model run folder
mkdir ${batch}/${badlands_model_run}/Uplift

## Copy all files required for badlands run to model run folder
cp -R Parameters_maps_${3}/* ${batch}/${badlands_model_run}/
## For tectonic uplift
mkdir Tectonic_Uplift/Split_features
mkdir Tectonic_Uplift/Feature_grids
mkdir Tectonic_Uplift/Smoothed_features

## Final csv files for Badlands
mkdir Final_uplift
mkdir Final_uplift/${dt_model}${s_dt}
mkdir Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}
mkdir Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}/LatLon

## Input lat lon values for study region
input_xy=LatLon${resol}.xy

shapefiles=$( ls Tectonic_Uplift/Uplift_shapefiles/*.shp )


### ----- Generate DT ages temp file ------------------------

ls "${dt_root}"/${dt_model}/Dynamic_topography/${Res}/${model_type}/${dt_model}_${model_type}${water}_dt*.${grid_type} | rev | awk -F"_" '{print $1}' | cut -c 4- | rev | cut -c 3- | sort -n > dt_ages_temp


# ### ----- Rotating and extracting dynamic topography grids --------------------------------------------
# ### Only need to run this section of script once for new dt models and/or scaling factors

# ages=$(awk '{print $0}' dt_ages_temp)

# echo $ages

# for age in $ages

#     do
#         ## Input Rot file
#         # in_rot="${dt_root}"/${dt_model}/ROTs/equivalent_total_rotation_comma_${age}.00Ma.csv
#         # haven't exported the total rotations for every model, AUS same as 241SZb
#         in_rot="${dt_root}"/gld241SZb/ROTs/equivalent_total_rotation_comma_${age}.00Ma.csv

#         rot=$( awk -F, '($1 == 801) {print $3, $2, $4*-1}' OFS='/' "$in_rot" )

#         ## Input Grid
#         dt_grid="${dt_root}"/${dt_model}/Dynamic_topography/${Res}/${model_type}/${scaled}${dt_model}_MantleFrame${water}${scale}_dt${age}.nc

#         ## Ouput file
#         dt_recon="${dt_root}"/${dt_model}_output/${scaled}Rotated/${dt_model}${water}_${age}_Ma.nc

#         ## Must produce a file for 0 Ma in same directory as rotated grids

#         if [ "${age}" -eq 0 ];
#         then

#             echo "No rotation applied to DT grid" ${age}
            
#             ## Must give a rotation value of zero to prevent grdmath error later in script "grids not of the same size"
#             gmt4 grdrotater "${dt_grid}" -G"${dt_recon}"  -Rd -T0/0/0 -V4


#             gmt grdsample -R${region} "${dt_recon}" -I0.1 -G"${dt_recon}"

     
#         elif [ "${age}" -gt 0 ];
#         then

#             echo "Rotating DT grid" ${age}

#             gmt4 grdrotater "${dt_grid}" -G"${dt_recon}"  -Rd -T${rot} -V4

#             gmt grdsample -R${region} "${dt_recon}" -I0.1 -G"${dt_recon}"

#         fi

# done


### ----- Calculate dynamic topography change -------------------------------------------------

### Adding index column to temporary ages file

awk '{print int((NR)) " " $0}' dt_ages_temp > ages_index.txt

index=$(awk '{print $1}' ages_index.txt)
echo "Index is" ${index}

max_index=$(awk 'max=="" || $1 > max {max=$1} END{ print max}' ages_index.txt)
echo "Max index is " ${max_index}
max_index=$((${max_index} - 1))


###-### Loop through dynamic topography grids to make change grids --------------------------------------
### if you want to only resample at higher resolution at final step you can comment out everything between ###-### 

index=1

while (($index <= ${max_index}))
do
  age=$( awk -v var=${index} '{ if ($1 == var) print $2 }' ages_index.txt)
  echo "Age is" ${age}

  next_age=$( awk -v var=${index} '{ if ($1 == var+1) print $2 }' ages_index.txt)
  echo "Next_age is" ${next_age}

  # Creating change grids for dynamic topography that will later be added to the tectonic uplift grids
  gmt grdmath ${dt_root}/${dt_model}_output/${scaled}Rotated/${dt_model}${water}_${age}_Ma.nc ${dt_root}/${dt_model}_output/${scaled}Rotated/${dt_model}${water}_${next_age}_Ma.nc SUB = ${dt_root}/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_${age}-${next_age}_Ma.nc -V

  # create original change grids for dynamic topography
  # gmt grdmath Dynamic_Topography/${dt_model}_output/Rotated/${dt_model}_${age}_Ma.nc Dynamic_Topography/${dt_model}_output/Rotated/${dt_model}_${next_age}_Ma.nc SUB = Dynamic_Topography/${dt_model}_output/Change_grid_originals/${dt_model}_diff_${age}-${next_age}_Ma_originals.nc

index=$((${index} + 1))
done

### ----- Extracting uplift values for each polygon from table of values ----------------------------------------

dos2unix ${batch}_uplift.csv

awk -F"," -v COLT=uplift_name '
        NR==1 {
                for (i=1; i<=NF; i++) {
                        if ($i==COLT) {
                              title=i;
                                print $i;
                      }
                }
        }
        NR>1 {
                if (i=title) {
                        print $i;
                }
        }
    ' ${batch}_uplift.csv > upliftnames.txt


awk -F"," -v COLT=${badlands_model_run} '
        NR==1 {
                for (i=1; i<=NF; i++) {
                        if ($i==COLT) {
                              title=i;
                                print $i;
                      }
                }
        }
        NR>1 {
                if (i=title) {
                        print $i;
                }
        }
    ' ${batch}_uplift.csv > upliftvariables.txt


paste upliftnames.txt upliftvariables.txt | awk '{if (NR!=1) {print}}' > all.txt


### ----- Adding tectonic uplift to dynamic topography change grids ------------------------------------


for shp in $shapefiles; do

    echo $shp

    ### Uplift file name without file extension
    gmt_outname=$( echo "$shp" | cut -d'.' -f1 )

    ### Only the name of the gmt file
    feature_name=$( echo "$gmt_outname" | cut -d'/' -f3)

    ### New segmented files including new folder path
    feature_path=Tectonic_Uplift/Split_features/${feature_name}

    ### Convert shp file to gmt
    ogr2ogr -f "GMT" ${gmt_outname}.gmt $shp

    ### Split shp file into multiple files for individual features
    ### feature = new segmented file
    ### gmt_outname = input gmt file created from the uplift shapefiles
    awk -v feature="${feature_path}" '/^>/{x++}{file = feature x ".gmt"; print >file}' ${gmt_outname}.gmt

    ### Add header to the beginning of every file
    echo "getting number from filename"

    cd Tectonic_Uplift/Split_features

    number=$(ls ${feature_name}*.gmt | sed 's/'${feature_name}'\(.*\)\.gmt/\1/' | sort -n)

    echo $number

    cd -

    for i in ${number}
      do
        cat ${feature_path}.gmt ${feature_path}${i}.gmt > temp && mv temp ${feature_path}${i}.gmt

        fromage=$( awk -F"|" '($1 == "# @D0") { print $2 }' ${feature_path}${i}.gmt)
        echo "from age of" ${feature_name} "file number" ${i} "is" $fromage

        toage=$(awk -F"|" '($1 == "# @D0") { print $3 }' ${feature_path}${i}.gmt)
        echo "to age of" ${feature_name} "file number" ${i} "is" $toage 

        # uplift=$(awk -F"|" '($1 == "# @D0") { print $4 }' ${feature_path}${i}.gmt)
        # echo "uplift of" ${feature_name} "file number" ${i} "is" $uplift

        uplift=$( awk -F' ' -v var=${feature_name}_${i} '($1 == var) {print $2}' all.txt )

        echo "uplift of" ${feature_name} "file number" ${i} "is" $uplift

        ### Find relevant dynamic topo grids using the temporal range in order to find out the proportion of uplift/subsidence applied to each temporal span

        max_dt_age=$( awk -v fromage=$fromage '($1 >= fromage) {print $1} ' dt_ages_temp | head -1 )
        echo "max age" $max_dt_age
        min_dt_age=$( awk -v toage=$toage '($1 <= toage) {print $1} ' dt_ages_temp | tail -1 )
        echo "min age" $min_dt_age

        file_count=0
        for change_grid in "${dt_root}"/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_*_Ma.nc

        do

          # echo $change_grid
          max_change_age=$( echo "$change_grid" | rev | awk -F"_" '{ print $2 }' | rev | awk -F"-" '{print $2}'  )
          min_change_age=$( echo "$change_grid" | rev | awk -F"_" '{ print $2 }' | rev | awk -F"-" '{print $1}'  )

          # echo $max_change_age $min_change_age
          if [ $min_change_age -ge $min_dt_age ] && [ $max_change_age -le $max_dt_age ] ; then

            echo "$change_grid"
          file_count=$(( $file_count + 1 ))

          fi

        done

        echo " File count is $file_count "

        uplift_per_time=$( echo " $uplift / $file_count " | bc )
        echo "Uplift per time is $uplift_per_time m"


        ### Make the uplift grid and apply grdfilter

        ### Grd mask to grid the gmt files
        gmt grdmask ${feature_path}${i}.gmt -R${region} -I${gmath_res} -N0/0/${uplift_per_time} -V -GTectonic_Uplift/Feature_grids/${feature_name}${i}.nc

        ### Smooth uplift feature grid
        gmt grdfilter Tectonic_Uplift/Feature_grids/${feature_name}${i}.nc -GTectonic_Uplift/Smoothed_features/${feature_name}${i}_smooth.nc -D0 -I${gfilter_res} -V -Fg${g_filter}


        ### Find relevant DT change csv files (recyled script from above) in order to add the proportion of uplift/subsidence applied to each temporal span to dt change grids

        for change_grid in "${dt_root}"/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_*_Ma.nc
        do

          ### echo $change_grid
          max_change_age=$( echo "$change_grid" | rev | awk -F"_" '{ print $2 }' | rev | awk -F"-" '{print $2}'  )
          min_change_age=$( echo "$change_grid" | rev | awk -F"_" '{ print $2 }' | rev | awk -F"-" '{print $1}'  )

          if [ $min_change_age -ge $min_dt_age ] && [ $max_change_age -le $max_dt_age ] ; then

          echo "$change_grid"

          echo "max change age is" $max_change_age
          echo "min change age is" $min_change_age

          ### Add smoothed tectonic uplift grid to change grid
          gmt grdmath ${dt_root}/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_${min_change_age}-${max_change_age}_Ma.nc Tectonic_Uplift/Smoothed_features/${feature_name}${i}_smooth.nc ADD = ${dt_root}/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_${min_change_age}-${max_change_age}_Ma.nc

          fi

        done

    done

done

###-### Grd track combined DT and tectonic grids -------------------------------------------------

echo "Start grd track"

index=1
while (($index <= ${max_index}))
do
  age=$( awk -v var=${index} '{ if ($1 == var) print $2 }' ages_index.txt)
  next_age=$( awk -v var=${index} '{ if ($1 == var+1) print $2 }' ages_index.txt)

  ### Produces csv with latlon
  ### Will be overwritten each time script is run
  gmt grdtrack -G${dt_root}/${dt_model}_output/${scaled}Change_grid/${dt_model}${water}_diff_${age}-${next_age}_Ma.nc ${input_xy} -V > Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}/LatLon/${dt_model}${water}_total_diff_${age}-${next_age}_Ma_latlon${resol}.csv


  ### Extracts uplift values into separate csv file
  ### Will be overwritten each time script is run
  awk -F" " '{ print $3 }' Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}/LatLon/${dt_model}${water}_total_diff_${age}-${next_age}_Ma_latlon${resol}.csv > Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}/${dt_model}${water}_total_diff_${age}-${next_age}_Ma${resol}.csv

  echo "done grid" ${age} "-" ${next_age}

  ### Copies final csv files to Badlands model run folder
  cp Final_uplift/${dt_model}${s_dt}/Filter_g${g_filter}/${dt_model}${water}_total_diff_${age}-${next_age}_Ma${resol}.csv ${batch}/${badlands_model_run}/Uplift/${dt_model}${water}_total_diff_${age}-${next_age}_Ma${resol}.csv

index=$((${index} + 1))
done

### ----- Remove temporary files -----------------

rm all.txt


