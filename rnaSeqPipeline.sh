#!/bin/bash
# This script is a locally optimized demonstration of an RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on cloud or an HPC cluster
#
# This script assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script takes paired-end sequence data in FastQ format and then generates a corresponding mapped.bam file -
# and a processed count matrix file ready for differential gene expression analysis
#
# A docker image containing all required packages to run this script can be pulled from jeaminj/data_process_tools 
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0

# Array containing srr accession numbers 
srrArray=("SRR15195418" "SRR15195419" "SRR15195427" "SRR15195428" "SRR15195438" "SRR15195439")

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
  fasterq-dump $srr -O ../rawData/
done

# Step [1]: Quality Control with fastqc
# ----------------------------------------------------------------------------------------------------
# Change to working directory
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
    --length_required 139

    echo "Trimming completed for" $srr ", outputs stored in "trimmedData" directory"
done

# Step [2.5]: quality checking the now trimmed data (ignoring unpaired reads)
# ----------------------------------------------------------------------------------------------------
fastqc trimmedData/*.fastq -o trimmedData/
echo "QC on paired trimmed data complete, begginning alignment!"

# Step [3]: Aligning with HISAT2
# ----------------------------------------------------------------------------------------------------
# obtain genome index from:
# wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz

for srr in ${srrArray[@]};
do
  #Set value for forward paired and reverse paired files
  fq_1p=${srr}_trimmed_1P.fastq
  fq_2p=${srr}_trimmed_2P.fastq

  echo begginning alignment of $srr to human genome
  hisat2 \
  -q \
  -x HISAT2/hisatGenomes/grch38/genome \
  -1 trimmedData/$fq_1p \
  -2 trimmedData/$fq_2p \
  | samtools sort -o mappedReads/${srr}.bam

done

# Step [4] Quantification with featureCounts
# ----------------------------------------------------------------------------------------------------
# download gtf file (variable to updates)
# wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz

# we will input all our bams in one command and get one output file
featureCounts \
-p --countReadPairs -s 0 -a index/Homo_sapiens.GRCh38.109.gtf \
-o quants/bc_tissue_featureCounts.txt mappedReads/*.bam

# Step [5] Process counts file for DeSEQ2/edgeR 
# ----------------------------------------------------------------------------------------------------
# Keeps only the GeneID and SRR# columns and rows and renames column headers to SRR#
(cat quants/bc_tissue_featureCounts.txt | cut -f1,7,8,9,10,11,12 | sed '1d' \
| sed -e "1s/mappedReads\/SRR15852426.bam/SRR15852426/g" \
-e "1s/mappedReads\/SRR15852396.bam/SRR15852396/g" \
-e "1s/mappedReads\/SRR15852429.bam/SRR15852429/g" \
-e "1s/mappedReads\/SRR15852399.bam/SRR15852399/g" \
-e "1s/mappedReads\/SRR15852443.bam/SRR15852443/g" \
-e "1s/mappedReads\/SRR15852413.bam/SRR15852413/g") > quants/bc_tissue_counts.txt

# -----------------------------------------------------------------------------------------------------

duration=SECONDS
echo "$((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
