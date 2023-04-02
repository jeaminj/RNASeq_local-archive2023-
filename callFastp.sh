#!/bin/bash
# This script is a locally optimized demonstration of RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on cloud or an HPC cluster
#
# This script assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script is only the trimming (step 2) step of rnaSeqPipeline.sh; It trims adapter sequences from the raw fastq files 
# and filters out any poor quality reads and sequences less than 125 bp 
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0

# Array containing srr accession numbers 
srrArray=("SRR15852396" "SRR15852426" "SRR15852429" "SRR15852399" "SRR15852443" "SRR15852413")

# directories
wd=/home
rawData=/home/rawData

for srr in ${srrArray[@]};
do
    #Set value for forward and reverse-read fastq files 
    fq_fwd=${srr}_1.fastq
    fq_rev=${srr}_2.fastq

# Step [2]: Trimming adapters and filtering with fastp
# ----------------------------------------------------------------------------------------------------
#change adapter file accordingly
cd $wd
echo "Starting fastp for" ${srr}

    fastp \
    -i rawData/$fq_fwd \
    -I rawData/$fq_rev \
    --out1 trimmedData/${srr}_trimmed_1P.fastq \
    --out2 trimmedData/${srr}_trimmed_2P.fastq \
    --length_required 125

    echo "Trimming completed for" $srr ", outputs stored in "trimmedData" directory"
done

duration=SECONDS
echo "Trimming done, $((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

# Check quality after trimming
fastqc trimmedData/*.fastq