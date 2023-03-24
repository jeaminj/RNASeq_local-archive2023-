#!/bin/bash
# This script is a locally optimized demonstration of RNASeq workflow, and thus does not contain the syntax or parameters 
# to be executed on an HPC cluster
#
# This script assumes all necessary packages are correctly installed in an (Anaconda) environment and will be run in such
# 
# This script takes paired-end sequence data in FastQ format and then generates a corresponding mapped.bam file -
# and a processed count matrix file ready for differential gene expression analysis
# 
# 
# ----------------------------------------------------------------------------------------------------
# timer
SECONDS=0
# Array containing srr accession numbers (
srrArray=("SRR15852396" "SRR15852426")
# working directories
sraDir=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/sra/
wd=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/
# adapter for trimming
adapter=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/adapters/TruSeq3-PE-2.fa

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

# (Optional) Delete files created from prefetch to free up disk space 
rm -r SRR*

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

# Step [2]: Trimming with trimmomatic
# ----------------------------------------------------------------------------------------------------
#change adapter file accordingly

    trimmomatic PE \
    -threads 4 \
    -phred33 \
    -trimlog trimmedData/${srr}_trimmed.log \
    rawData/$fq_fwd rawData/$fq_rev \
    -baseout trimmedData/${srr}_trimmed.fastq \
    ILLUMINACLIP:$adapter:2:30:10 LEADING:3 TRAILING:3 MINLEN:36  

    echo "Trimming completed for" $srr ", outputs stored in /trimmedData"
done

# Step [2.5]: quality checking the now trimmed data (ignoring unpaired reads)
# ----------------------------------------------------------------------------------------------------
fastqc trimmedData/*P.fastq -o trimmedData/
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
  -q --rna-strandness R \
  -x HISAT2/hisatGenomes/grch38/genome \
  -1 trimmedData/$fq_1p \
  -2 trimmedData/$fq_2p \
  | samtools sort -o mappedReads/${srr}.bam

done

# Step [4] Quantification with featureCounts
# ----------------------------------------------------------------------------------------------------
# download gtf file (variable to updates)
# wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz

# we will input both our bams in one command and get one output file
featureCounts \
-p -s 2 -a index/Homo_sapiens.GRCh38.109.gtf \
-o quants/bc_tissue_featureCounts.txt mappedReads/SRR15852396.bam mappedReads/SRR15852426.bam

# Step [5] Process counts file for DeSEQ2/edgeR 
# ----------------------------------------------------------------------------------------------------
# Removes columns and rows that are not needed for the next step and renames column headers to SRR#
(cat quants/bc_tissue_featureCounts.txt | cut -f1,7,8 | sed '1d' \
| sed -e "1s/mappedReads\/SRR15852396.bam/SRR15852396/g" \
-e "1s/mappedReads\/SRR15852426.bam/SRR15852426/g") > quants/bc_tissue_counts.txt

# -----------------------------------------------------------------------------------------------------

duration=SECONDS
echo "$((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
