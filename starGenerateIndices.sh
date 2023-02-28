#!/usr/bin/bash

#Assumes script is run in environment containing neccessary packages
#100GB of free disk space is recommended before running

#change working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/

echo "Generating RNASTAR genome files"
#Create genome index for STAR to utilize
STAR \
--runMode genomeGenerate \
--genomeDir index/starGenome/ \
--genomeFastaFiles index/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
--sjdbGTFfile index/Homo_sapiens.GRCh38.108.gtf \
--runThreadN 4

duration=SECONDS
echo "Done! $((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."