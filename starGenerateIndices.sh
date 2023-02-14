#!/usr/bin/bash

#Assumes script is run in environment containing neccessary packages

#change working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/

echo "Generating RNASTAR genome files"
#Create genome index for STAR to utilize
STAR \
--runMode genomeGenerate \
--genomeDir index/starRefs/ \
--genomeFastaFiles index/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
--sjdbGTFfile index/Homo_sapiens.GRCh38.108.gtf \
--runThreadN 4

echo "Index generation complete!"

"test edit"



