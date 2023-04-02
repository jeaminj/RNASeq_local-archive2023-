#!/bin/bash
# This script is a locally optimized demonstration of an RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on cloud or an HPC cluster
#
# This script is assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script is only the alignment step (step 3) of rnaSeqPipeline.sh, that takes trimmed fastq sequences and 
# generates a mapped bam file
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0

# Array containing srr accession numbers 
srrArray=("SRR15852396" "SRR15852426" "SRR15852429" "SRR15852399" "SRR15852443" "SRR15852413")

# working directory
wd=/home

# Step [3]: Aligning with HISAT2
# ----------------------------------------------------------------------------------------------------
# obtain genome index from:
# wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
cd $wd 

for srr in ${srrArray[@]};
do
  #Set value for forward paired and reverse paired files
  fq_1p=${srr}_trimmed_1P.fastq
  fq_2p=${srr}_trimmed_2P.fastq

  echo begginning alignment of $srr to human genome
  hisat2 \
  -q --rna-strandness RF \
  -x HISAT2/grch38/genome \
  -1 trimmedData/$fq_1p \
  -2 trimmedData/$fq_2p \
  | samtools sort -o mappedReads2/${srr}.bam

done

duration=SECONDS
echo "Trimming done, $((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."