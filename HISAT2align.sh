#!/bin/bash
#script for alignment of paired end reads with hisat2
#set working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/

srrArray=("SRR15852396" "SRR15852426")

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

echo "alignment complete!"