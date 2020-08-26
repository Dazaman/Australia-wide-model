# for model in AUSLG018 AUSLG019 AUSLG020 AUSLG021 AUSLG022 AUSLG023 #AUSLG004 AUSLG005 AUSLG006 AUSLG007 AUSLG008 AUSLG009 AUSLG010 #AUSLG001 AUSLG002 AUSLG003
# do

batch=AUSB

mkdir ${batch}
mkdir ${batch}/Input_xmls

for num in {004..004}
do
	model=$(printf "%03d" $num)
	model=${batch}${model}

	./badlands_input_files.sh ${model} ${batch}

done
# ./badlands_input_files.sh AUSLG002
# ./badlands_input_files.sh AUSLG003
## DDC75J22