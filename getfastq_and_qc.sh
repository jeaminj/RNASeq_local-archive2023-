#!/bin/bash
# This script is a locally optimized demonstration of RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on cloud or an HPC cluster
#
# This script assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script is only the data retrieval (step 0) and quality control (step 1) steps of rnaSeqPipeline.sh; It downloads fastq files 
# and performs fastqc 
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0

# Array containing srr accession numbers 
srrArray=("SRR15852396" "SRR15852426" "SRR15852429" "SRR15852399" "SRR15852443" "SRR15852413")

# directories
sraDir=/home/sra/
wd=/home
rawData=/home/rawData
# Step [0]: Retrieve SRA Data (To be commented out if data already in possession)
# ----------------------------------------------------------------------------------------------------
# Use sra-tools 2.10, updated version does not work
# Set working directory to sraDir
cd $sraDir

for srr in ${srrArray[@]};
do 
  echo "starting data retrieval of" $srr
  prefetch $srr
  echo "begginning fasterq-dump, fastq files will be stored in rawData/"
  fasterq-dump $srr -O ../rawData
done

# Step [1]: Quality Control with fastqc
# ----------------------------------------------------------------------------------------------------
# Change to working directoryy

cd $wd

for srr in ${srrArray[@]};
do
    #Set value for forward and reverse-read fastq files 
    fq_fwd=${srr}_1.fastq
    fq_rev=${srr}_2.fastq

    #FastQC on forward reads
    fastqc rawData/$fq_fwd -o rawData/

    #FastQC on reverse reads
    fastqc rawData/$fq_rev -o rawData/

    echo "FastQC done, reports stored in rawData/"
done

duration=SECONDS
echo "$((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
