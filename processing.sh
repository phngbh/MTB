#!/bin/bash

cd $HOME/Helmholtz/MTB

if [[ -d processed ]] 
	then
		echo "Folder processed exists, making new folder..." 
		rm -rf processed
		mkdir processed
	else
		echo Making folder processed
		mkdir processed 
fi

if [[ -s CombinedVariant.txt ]] 
then
	echo "Old result exists, deleting..."
	rm -rf CombinedVariant.txt
fi 

for i in $(ls Neuer_Ordner/*.tsv);do
	prefix="Neuer_Ordner/"
	suffix="_CombinedVariantOutput.tsv"
	name=${i#"$prefix"}
	name=${name%"$suffix"}
	tmb=$(awk -F "\t" '/Total TMB/{print $2}' $i)
	msi=$(awk -F "\t" '/Percent Unstable MSI Sites/{print $2}' $i)
	nline=$(wc -l $i | awk '{print $1}')
	awk -F "\t" -v line=$nline '/Small Variants/{i=1;next};i && i++ <= line' $i | sed -e "s/$/ $tmb $msi $name/" | awk '$1 != "Gene"{print}' > processed/"${name}".tsv 
	#awk -F "\t" 'NF>=9 && !/Chromosome/{print}' Neuer_Ordner/"${name}"_CombinedVariantOutput.tsv | sed -e "s/$/\t$tmb\t$msi\t$name/"  > processed/"${name}".tsv 
	cat processed/"${name}".tsv >> CombinedVariant.txt
done