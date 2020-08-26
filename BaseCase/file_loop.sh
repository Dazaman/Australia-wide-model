## To loop through input generation files based on batch name and number range

batch=AUSB

mkdir ${batch}
mkdir ${batch}/Input_xmls

for num in {001..001}
do
	model=$(printf "%03d" $num)
	model=${batch}${model}

	./badlands_input_files.sh ${model} ${batch}

done
