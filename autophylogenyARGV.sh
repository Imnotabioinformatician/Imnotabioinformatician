#!/bin/bash
# If code doesn"t work remember to run chmod +x nameofthisscript.sh
# Author; Luis A Yanez-Guerra @Imnotabioinformatician https://github.com/Imnotabioinformatician

mkdir -p ./aligned/ 
shopt -s extglob

for wd in "$1"/*.fa* #This can be changed according to the extension of the file, in this case is assumed that all the folders have the ext .BUSCO
do

    sed -i -e "s,\.,_,g" -e 's. ._.g' -e 's.\+._.g' -e 's.\:._.g' -e 's.\;._.g' \
    -e 's.|._.g' -e 's.{._.g' -e 's.\[._.g' -e 's.(._.g' -e 's.}._.g' -e 's.]._.g' \
    -e 's.)._.g' -e 's.\^._.g' -e 's.\$._.g' -e 's.,._.g' -e 's.?._.g' -e 's.*..g' -e 's.-..g' \
    -e 's."._.g' -e  's.\\._.g' -e 's./._.g' -e 's.#._.g' -e 's.~._.g' -e 's.!._.g' -e "s.'._.g" -e 's.%._.g'   "${wd}"


    mafft-einsi $wd > ${wd}.einsialn
    mv $wd.einsialn ./aligned/
    done 

echo "============"
echo "=====m======"
echo "trimming"
echo "============"
echo "============"

mkdir -p ./trimmed/

for k in aligned/*aln #This can be changed according to the extension of the file, in this case is assumed that all the folders have the ext .BUSCO
do
	trimal -in $k -out ${k}auto.fasta -automated1 -htmlout ${k}auto.html

    trimal -in $k -out ${k}gapp.fasta -gappyout -htmlout ${k}gapp.html
    mv $k*.fasta ./trimmed/
    mv $k*.html ./trimmed/

#done
    
mkdir -p trimmed_aln
for iq in trimmed/*fasta #This can be changed according to the extension of the file, in this case is assumed that all the folders have the ext .BUSCO
do
	iqtree2 -s $iq -mset WAG,LG,Blosum62,Dayhoff,JTT,Poisson -B 1000 -alrt 1000 -T AUTO
    #iqtree2 -m LG+G4+F -B 1000 -wbt -alrt 1000 -T auto
    mv $iq ./trimmed_aln/
   
done
    
mv trimmed final_phylogeny
mv final_phylogeny/*.html  ./trimmed_aln/
echo "=========================your phylogeny is readyyy===================================="
echo "========================================================================"

echo "========files are in folder Completed_phylogenomic_analysis============="
echo "========================================================================"
