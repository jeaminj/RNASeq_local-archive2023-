#!/bin/bash
# This script is a locally optimized demonstration of RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on cloud or an HPC cluster
#
# This script assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script is only the quantification step (step 4) of rnaSeqPipeline.sh, that takes the generated bam file from the previous step and 
# generates a processed count matrix file, ready for differential gene expression analysis
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0

# working directory
wd=/home

cd $wd 

# Step [4] Quantification with featureCounts
# ----------------------------------------------------------------------------------------------------
# download gtf file (variable to updates)
# wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.109.gtf.gz

# we will input both our bams in one command and get one output file
featureCounts \
-p --countReadPairs -s 2 -a index/Homo_sapiens.GRCh38.109.gtf \
-o quants/bc_tissue_featureCounts3.txt mappedReads2/*.bam

# Step [5] Process counts file for DeSEQ2/edgeR 
# ----------------------------------------------------------------------------------------------------
# Keeps only the GeneID and SRR# columns and rows and renames column headers to SRR#
(cat quants/bc_tissue_featureCounts3.txt | cut -f1,7,8,9,10,11,12 | sed '1d' \
| sed -e "1s/mappedReads2\/SRR15852426.bam/SRR15852426/g" \
-e "1s/mappedReads2\/SRR15852396.bam/SRR15852396/g" \
-e "1s/mappedReads2\/SRR15852429.bam/SRR15852429/g" \
-e "1s/mappedReads2\/SRR15852399.bam/SRR15852399/g" \
-e "1s/mappedReads2\/SRR15852443.bam/SRR15852443/g" \
-e "1s/mappedReads2\/SRR15852413.bam/SRR15852413/g") > quants/bc_tissue_counts3.txt
# -----------------------------------------------------------------------------------------------------

duration=SECONDS
echo "$((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
