#!/bin/bash
# If code doesn't work remember to run chmod +x nameofthisscript.sh
# @Luis Yanez-Guerra @Imnotabioinformatician https://github.com/Imnotabioinformatician

echo "============"
echo "=====m======"
echo "performing busco analysis first "
echo "============"
echo "============"
echo "---please provide the database to use for your busco analysis, if in doubt please read the BUSCO documentation----"
echo "---for example: default for animals is metazoa_odb10 if you wish you use this write metazoa_odb10 (including underscore)----"
read databasetouse

mkdir -p ./Proces_proteome
mkdir -p ./BUSCOanalysis

for i in Proteome_input/*.fa*
do
	
	transcriptome_name="${i#Proteome_input/}"
	Species="${transcriptome_name%.fasta}"
	
	busco -m protein -i $i -o "${Species}.BUSCO" -l $databasetouse
 	mv $i "./Proces_proteome"
 	mv "${Species}.BUSCO" ./BUSCOanalysis/
done


echo "--------------------------------------------------------------"
echo " "
echo "All proteomes have been processed"
echo " "
echo "--------------------------------------------------------------"
echo " "
echo "completeness analysis of predicted proteome from ${i} finished"
echo " "

mkdir -p ./bsco_summaries
cp ./BUSCOanalysis/*.BUSCO/short_summary.*.txt ./bsco_summaries/
python3 ./Apps/generate_plot.py -wd bsco_summaries

echo "results are ready in the folder bsco_summaries/"
