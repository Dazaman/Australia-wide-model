
for dt_model in gmcm9c #gld89 gld95 gld98 gld106 gld107 #gld241 #gld177 gld178 gld185 gld200
do
# dt_model="gld281"

model_type="MantleFrame"
Res="HiRes"
grid_type="nc"
scale_factor=1


scale="_Scaled"
scaled="Scaled_"${dt_model}"_"${scale_factor}"/"
s_dt="_"${scale_factor}
## Grid region - resample grids to same dimension and resolution, smaller region reduces runtime 
region=82/179.9/-55/12

dt_root=/home/danial/Badlands_workflow/Badlands_workflow/Dynamic_Topography

mkdir ${dt_root}/${dt_model}/Dynamic_topography/${Res}/${model_type}/Scaled_${dt_model}_${scale_factor}
mkdir ${dt_root}/${dt_model}_output
mkdir ${dt_root}/${dt_model}_output/${scaled}
mkdir ${dt_root}/${dt_model}_output/${scaled}Rotated


## Generate DT ages temp file
ls ${dt_root}/${dt_model}/Dynamic_topography/${Res}/${model_type}/${dt_model}_${model_type}_dt*.${grid_type} | rev | awk -F"_" '{print $1}' | cut -c 4- | rev | cut -c 3- | sort -n > dt_ages_temp

# Scaling each of the dynamic topography grids

ages=$(awk '{print $0}' dt_ages_temp)
echo $ages

for age in $ages
    do

		gmt grdmath ${dt_root}/${dt_model}/Dynamic_topography/${Res}/${model_type}/${dt_model}_${model_type}_dt${age}.${grid_type} ${scale_factor} MUL = ${dt_root}/${dt_model}/Dynamic_topography/${Res}/${model_type}/Scaled_${dt_model}_${scale_factor}/${dt_model}_${model_type}_Scaled_dt${age}.nc -V


        
        
        ## Input Rot file
        # in_rot="${dt_root}"/${dt_model}/ROTs/equivalent_total_rotation_comma_${age}.00Ma.csv
        # haven't exported the total rotations for every model, AUS same as 241SZb
        in_rot="${dt_root}"/ROTs/equivalent_total_rotation_comma_${age}.00Ma.csv

        rot=$( awk -F, '($1 == 801) {print $3, $2, $4*-1}' OFS='/' "$in_rot" )
        

        ## Input Grid
        dt_grid="${dt_root}"/${dt_model}/Dynamic_topography/${Res}/${model_type}/${scaled}${dt_model}_MantleFrame${water}${scale}_dt${age}.nc

        ## Ouput file
        dt_recon="${dt_root}"/${dt_model}_output/${scaled}Rotated/${dt_model}${water}_${age}_Ma.nc

        ## Must produce a file for 0 Ma in same directory as rotated grids

        if [ "${age}" -eq 0 ];
        then

            echo "No rotation applied to DT grid" ${age}
            
            ## Must give a rotation value of zero to prevent grdmath error later in script "grids not of the same size"
            gmt grdrotater "${dt_grid}" -G"${dt_recon}"  -Rd -E0/0/0 -V4


            gmt grdsample -R${region} "${dt_recon}" -I0.1 -G"${dt_recon}"

     
        elif [ "${age}" -gt 0 ];
        then

            echo "Rotating DT grid" ${age}

            gmt grdrotater "${dt_grid}" -G"${dt_recon}"  -Rd -E${rot} -V4

            gmt grdsample -R${region} "${dt_recon}" -I0.1 -G"${dt_recon}"

        fi

done
done


