#!/bin/bash


## Bash script to generate xml files for badlands input
## When generating script specify the model name e.g. test.sh AUSLP001 1

batch=$2

dos2unix ${batch}_variables.csv

# awk -F, '{FS="\t"}; {print $3}' badlands_variables_2.csv > modelvariables.txt

# Pulls parameters from specified model run, prints to new file
awk -F"," -v COLT=$1 '
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
' ${batch}_variables.csv > modelvariables.txt

# Reads in parameters for model run from new file and assigns them to variables in the form ${variables[i]}, where i is the line number
while read variable; do
    variables+=($variable)
done < modelvariables.txt

echo "Generating xml file for model run:" ${variables[0]}

# if [ "${variables[1]}" == "gmcm9c" ]; then
events=30

  # echo $events

# fi

cat > ${variables[0]}.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<badlands xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- Regular grid structure -->
    <grid>
        <!-- Digital elevation model file path -->
        <demfile>${variables[0]}/Paleotopo/Paleotopo_${variables[3]}_${variables[2]}_prec2.csv</demfile>
        <!-- Boundary type: flat, slope or wall -->
        <boundary>slope</boundary>
        <!-- Optional parameter (integer) used to decrease TIN resolution.
             The default value is set to 1. Increasing the factor
             value will multiply the digital elevation model resolution
             accordingly.  -->
        <resfactor>${variables[14]}</resfactor>
    </grid>

    <!-- Simulation time structure -->
    <time>
        <!-- Simulation start time [a] -->
        <start>${variables[15]}</start>
        <!-- Simulation end time [a] -->
        <end>${variables[16]}</end>
        <!-- Display interval [a] -->
        <display>${variables[17]}</display>
    </time>

    <!-- Simulation stratigraphic structure -->
    <strata>
        <!-- Stratal grid resolution [m] -->
        <stratdx>${variables[18]}.</stratdx>
        <!-- Stratal layer interval [a] -->
        <laytime>${variables[17]}</laytime>
        <!-- Surface porosity -->
        <poro0>0.49</poro0>
        <!-- characteristic constant for Athy's porosity law [/km] -->
        <poroC>0.27</poroC>
    </strata>

    <!--  Sea-level structure  -->
    <sea>
        <!--  Relative sea-level position [m]  -->
        <position>0.</position>
        <!--  Sea-level curve - (optional)  -->
        <curve>${variables[0]}/Sea_level/${variables[9]}.csv</curve>
    </sea>
    
    <!--  Tectonic structure  -->
    <tectonic>
        <!--
         Is 3D displacements on ? (1:on - 0:off). Default is 0.
         -->
        <disp3d>0</disp3d>
        <!--  Number of tectonic events  -->
        <events>${events}</events>
        <!--  Displacement definition  -->
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-150.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-145.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_145-150_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-145.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-140.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_140-145_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-140.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-135.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_135-140_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-135.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-129.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_130-135_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-129.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-124.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_125-130_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-124.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-119.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_120-125_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-119.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-114.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_115-120_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-114.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-109.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_110-115_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-109.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-104.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_105-110_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-104.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-99.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_100-105_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-99.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-94.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_95-100_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-94.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-89.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_90-95_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-89.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-84.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_85-90_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-84.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-79.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_80-85_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-79.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-74.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_74-80_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-74.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-69.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_69-74_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-69.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-64.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_64-69_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-64.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-59.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_59-64_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-59.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-54.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_54-59_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-54.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-49.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_49-54_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-49.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-44.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_44-49_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-44.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-39.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_39-44_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-39.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-34.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_34-39_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-34.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-29.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_29-34_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-29.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-24.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_24-29_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-24.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-19.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_19-24_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-19.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-14.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_14-19_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-14.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-9.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_9-14_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-9.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-4.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_4-9_Ma_${variables[2]}.csv</dfile>
        </disp>
        <disp>
            <!--  Displacement start time [a]  -->
            <dstart>-4.e6</dstart>
            <!--  Displacement end time [a]  -->
            <dend>-0.e6</dend>
            <!--  Displacement map [m]  -->
            <dfile>${variables[0]}/Uplift/gmcm9c_total_diff_0-4_Ma_${variables[2]}.csv</dfile>
        </disp>
    </tectonic>
EOF

if [ "${variables[19]}" == "4" ]; then

cat >> ${variables[0]}.xml << EOF
    <!--  Precipitation structure  -->
    <precipitation>
        <!--  Number of precipitation events  -->
        <climates>4</climates>
        <!--  Precipitation definition  -->
        <!-- Linear orographic precipitation model definition -->
        <rain>
          <!-- Rain start time [a] -->
          <rstart>-150.e6</rstart>
          <!-- Rain end time [a] -->
          <rend>-40.e6</rend>
          <!-- Precipitation map [m/a] -->
          <rval>1.16</rval>
        </rain>
        <rain>
        <!-- Rain start time [a] -->
          <rstart>-40.e6</rstart>
          <!-- Rain end time [a] -->
          <rend>-20.e6</rend>
          <!-- Precipitation map [m/a] -->
          <rval>0.9</rval>
        </rain>
        <rain>
          <!-- Rain start time [a] -->
          <rstart>-20.e6</rstart>
          <!-- Rain end time [a] -->
          <rend>-10.e6</rend>
          <!-- Precipitation map [m/a] -->
          <rval>1.092</rval>
        </rain>
        <rain>
          <!-- Rain start time [a] -->
          <rstart>-10.e6</rstart>
          <!-- Rain end time [a] -->
          <rend>0.</rend>
          <!-- Rain computation time step [a] -->
          <ortime>100000.</ortime>
          <!-- Minimal precipitation value [m/a] -->
          <rmin>1.</rmin>
          <!-- Maximal precipitation value [m/a] -->
          <rmax>5.</rmax>
          <!-- Maximal elevation for computing linear trend [m] -->
          <rzmax>4000.</rzmax>
        </rain>
    </precipitation>
EOF

else

cat >> ${variables[0]}.xml << EOF
    <!--  Precipitation structure  -->
    <precipitation>
        <!--  Number of precipitation events  -->
        <climates>1</climates>
        <!--  Precipitation definition  -->
        <!-- Linear orographic precipitation model definition -->
        <rain>
          <!-- Rain start time [a] -->
          <rstart>-149.e6</rstart>
          <!-- Rain end time [a] -->
          <rend>0.</rend>
          <!-- Rain computation time step [a] -->
          <ortime>100000.</ortime>
          <!-- Minimal precipitation value [m/a] -->
          <rmin>1.</rmin>
          <!-- Maximal precipitation value [m/a] -->
          <rmax>${variables[38]}</rmax>
          <!-- Maximal elevation for computing linear trend [m] -->
          <rzmax>${variables[39]}</rzmax>
        </rain>
    </precipitation>
EOF

fi

cat >> ${variables[0]}.xml << EOF
    <!--
     Stream power law parameters:
     The stream power law is a simplified form of the usual expression of
     sediment transport by water flow, in which the transport rate is assumed
     to be equal to the local carrying capacity, which is itself a function of
     boundary shear stress.
     -->
    <sp_law>
        <!-- Critical slope used to force aerial deposition for alluvial plain,
        in [m/m] (optional). -->
        <slp_cr>${variables[20]}</slp_cr>
        <!-- Maximum percentage of deposition at any given time interval from rivers
             sedimentary load in alluvial plain. Value ranges between [0,1] (optional). -->
        <perc_dep>${variables[21]}</perc_dep>
        <!--
         Planchon & Darboux filling thickness limit [m]. This parameter is used
         to defined maximum accumulation thickness in depression area per time
         step. Default value is set to 1.
         -->
        <!--fillmax>1.</fillmax-->
        <!--
         Values of m and n indicate how the incision rate scales
         with bed shear stress for constant value of sediment flux
         and sediment transport capacity.
         Generally, m and n are both positive, and their ratio
         (m/n) is considered to be close to 0.5
         -->
        <m>${variables[22]}</m>
        <n>${variables[23]}</n>
        <!--
         The erodibility coefficient is scale-dependent and its value depend
         on lithology and mean precipitation rate, channel width, flood
         frequency, channel hydraulics.
        -->
        <erodibility>${variables[12]}</erodibility>
        <!-- Number of steps used to distribute marine deposit.
             Default value is 5 (integer). -->
        <diffnb>${variables[24]}</diffnb>
        <!-- Proportion of marine sediment deposited on downstream nodes. It needs
             to be set between ]0,1[. Default value is 0.9 (optional). -->
        <diffprop>${variables[13]}</diffprop>
    </sp_law>

    <!-- Erodibility structure simple
         This option allows you to specify different erodibility values either on the surface
        or within a number of initial stratigraphic layers. -->
    <erocoeff>
        <!-- Number of erosion layers. -->
        <erolayers>${variables[25]}</erolayers>
        <!-- The layering is defined from top to bottom, with:
            - either a constant erodibility value for the entire layer or with an erodibility map
            - either a constant thickness for the entire layer or with a thickness map -->
        <!-- Variable erodibilities and constant layer thickness -->
        <erolay>
            <!-- Variable erodibilities for the considered layer. -->
            <eromap>${variables[0]}/Erodibility/Erodibility_CordArc_${variables[11]}_${variables[2]}.csv</eromap>
            <!-- Uniform thickness value for the considered layer [m]. -->
            <thcst>${variables[26]}</thcst>
        </erolay>
        <erolay>
            <!-- Variable erodibilities for the considered layer. -->
            <eromap>${variables[0]}/Erodibility/Erodibility_TasLine_${variables[11]}_${variables[2]}.csv</eromap>
            <!-- Uniform thickness value for the considered layer [m]. -->
            <thcst>${variables[27]}</thcst>
        </erolay>
        <erolay>
            <!-- Variable erodibilities for the considered layer. -->
            <eromap>${variables[0]}/Erodibility/Erodibility_CordArc_${variables[11]}_${variables[2]}.csv</eromap>
            <!-- Uniform thickness value for the considered layer [m]. -->
            <thcst>${variables[28]}</thcst>
        </erolay>
    </erocoeff>
    

    <!--
     Linear slope diffusion parameters:
     Parameterisation of the sediment transport includes the simple creep transport
     law which states that transport rate depends linearly on topographic gradient.
     -->
    <creep>
        <!--  Surface diffusion coefficient [m2/a]  -->
        <caerial>${variables[29]}</caerial>
        <!--  Marine diffusion coefficient [m2/a]  -->
        <cmarine>${variables[30]}</cmarine>
        <!-- River transported sediment diffusion
             coefficient in marine realm [m2/a] -->
        <criver>${variables[31]}</criver>
    </creep>
    <flexure>
        <!--  Time step used to compute the isostatic flexure.  -->
        <ftime>${variables[32]}</ftime>
        <!--
         Definition of the flexural grid:
         It is possible to setup a flexural grid at a resolution higher than the one used
         for the TIN to increase computational speed. In this case you need to define the
         discretization along X and Y axis. By default the same resolution as the one given
         for the DEM file is used and the following 2 parameters are not required.
         -->
        <!--  Number of points along the X-axis - (optional) -->
        <!-- flex_dx>${variables[33]}</flex_dx -->
        <!--  Mantle density [km/m3]  -->
        <dmantle>${variables[34]}</dmantle>
        <!--  Sediment density [km/m3]  -->
        <dsediment>${variables[35]}</dsediment>
        <!--  Youngs Modulus [Pa]  -->
        <youngMod>${variables[36]}</youngMod>
EOF

if [ "${variables[37]}" == "AB_map80" ]; then


cat >> ${variables[0]}.xml << EOF
        <!-- 
         The lithospheric elastic thickness (Te) can be expressed as a scalar if you assume
         a uniform thickness for the model area in this case the value is given in the next
         parameter [m] - (optional)
         -->
        <elasticGrid>${variables[0]}/Flexure/AB_map80.csv</elasticGrid>
        <!--
         Finite difference boundary conditions:
         + 0Displacement0Slope: 0-displacement-0-slope boundary condition
         + 0Moment0Shear: "Broken plate" boundary condition: second and
         third derivatives of vertical displacement are 0. This
         is like the end of a diving board.
         + 0Slope0Shear: First and third derivatives of vertical displacement
         are zero. While this does not lend itsellf so easily to
         physical meaning, it is helpful to aid in efforts to make
         boundary condition effects disappear (i.e. to emulate the
         NoOutsideLoads cases)
         + Mirror: Load and elastic thickness structures reflected at boundary.
         + Periodic: "Wrap-around" boundary condition: must be applied to both
         North and South and/or both East and West. This causes, for
         example, the edge of the eastern and western limits of the domain
         to act like they are next to each other in an infinite loop.
         The boundary are defined for each edges W, E, S and N.
         -->
        <boundary_W>Mirror</boundary_W>
        <boundary_E>Mirror</boundary_E>
        <boundary_S>Mirror</boundary_S>
        <boundary_N>Mirror</boundary_N>
    </flexure>

     <!-- Output folder path -->
    <outfolder>Output/${variables[0]}_output</outfolder>

</badlands>
EOF

elif [ "${variables[37]}" == "AB_map100" ]; then

cat >> ${variables[0]}.xml << EOF
        <!-- 
         The lithospheric elastic thickness (Te) can be expressed as a scalar if you assume
         a uniform thickness for the model area in this case the value is given in the next
         parameter [m] - (optional)
         -->
        <elasticGrid>${variables[0]}/Flexure/AB_map100.csv</elasticGrid>
        <!--
         Finite difference boundary conditions:
         + 0Displacement0Slope: 0-displacement-0-slope boundary condition
         + 0Moment0Shear: "Broken plate" boundary condition: second and
         third derivatives of vertical displacement are 0. This
         is like the end of a diving board.
         + 0Slope0Shear: First and third derivatives of vertical displacement
         are zero. While this does not lend itsellf so easily to
         physical meaning, it is helpful to aid in efforts to make
         boundary condition effects disappear (i.e. to emulate the
         NoOutsideLoads cases)
         + Mirror: Load and elastic thickness structures reflected at boundary.
         + Periodic: "Wrap-around" boundary condition: must be applied to both
         North and South and/or both East and West. This causes, for
         example, the edge of the eastern and western limits of the domain
         to act like they are next to each other in an infinite loop.
         The boundary are defined for each edges W, E, S and N.
         -->
        <boundary_W>Mirror</boundary_W>
        <boundary_E>Mirror</boundary_E>
        <boundary_S>Mirror</boundary_S>
        <boundary_N>Mirror</boundary_N>
    </flexure>

     <!-- Output folder path -->
    <outfolder>Output/${variables[0]}_output</outfolder>

</badlands>
EOF

elif [ "${variables[37]}" == "AB_map120" ]; then

cat >> ${variables[0]}.xml << EOF
        <!-- 
         The lithospheric elastic thickness (Te) can be expressed as a scalar if you assume
         a uniform thickness for the model area in this case the value is given in the next
         parameter [m] - (optional)
         -->
        <elasticGrid>${variables[0]}/Flexure/AB_map120.csv</elasticGrid>
        <!--
         Finite difference boundary conditions:
         + 0Displacement0Slope: 0-displacement-0-slope boundary condition
         + 0Moment0Shear: "Broken plate" boundary condition: second and
         third derivatives of vertical displacement are 0. This
         is like the end of a diving board.
         + 0Slope0Shear: First and third derivatives of vertical displacement
         are zero. While this does not lend itsellf so easily to
         physical meaning, it is helpful to aid in efforts to make
         boundary condition effects disappear (i.e. to emulate the
         NoOutsideLoads cases)
         + Mirror: Load and elastic thickness structures reflected at boundary.
         + Periodic: "Wrap-around" boundary condition: must be applied to both
         North and South and/or both East and West. This causes, for
         example, the edge of the eastern and western limits of the domain
         to act like they are next to each other in an infinite loop.
         The boundary are defined for each edges W, E, S and N.
         -->
        <boundary_W>Mirror</boundary_W>
        <boundary_E>Mirror</boundary_E>
        <boundary_S>Mirror</boundary_S>
        <boundary_N>Mirror</boundary_N>
    </flexure>

     <!-- Output folder path -->
    <outfolder>Output/${variables[0]}_output</outfolder>

</badlands>
EOF

else

cat >> ${variables[0]}.xml << EOF
        <!-- 
         The lithospheric elastic thickness (Te) can be expressed as a scalar if you assume
         a uniform thickness for the model area in this case the value is given in the next
         parameter [m] - (optional)
         -->
        <elasticH>${variables[37]}</elasticH>
        <!--
         Finite difference boundary conditions:
         + 0Displacement0Slope: 0-displacement-0-slope boundary condition
         + 0Moment0Shear: "Broken plate" boundary condition: second and
         third derivatives of vertical displacement are 0. This
         is like the end of a diving board.
         + 0Slope0Shear: First and third derivatives of vertical displacement
         are zero. While this does not lend itsellf so easily to
         physical meaning, it is helpful to aid in efforts to make
         boundary condition effects disappear (i.e. to emulate the
         NoOutsideLoads cases)
         + Mirror: Load and elastic thickness structures reflected at boundary.
         + Periodic: "Wrap-around" boundary condition: must be applied to both
         North and South and/or both East and West. This causes, for
         example, the edge of the eastern and western limits of the domain
         to act like they are next to each other in an infinite loop.
         The boundary are defined for each edges W, E, S and N.
         -->
        <boundary_W>Mirror</boundary_W>
        <boundary_E>Mirror</boundary_E>
        <boundary_S>Mirror</boundary_S>
        <boundary_N>Mirror</boundary_N>
    </flexure>

     <!-- Output folder path -->
    <outfolder>Output/${variables[0]}_output</outfolder>

</badlands>
EOF

fi

mv ${variables[0]}.xml ${batch}/${variables[0]}.xml

echo "xml output complete"