#!/bin/bash
#script for alignment of paired end reads with hisat2
#set working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/

fastq_reads=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/trimmedData

for base in SRR15852396_tumor SRR15852426_normal
do
  echo $base

  #defines R1 and R2 fastq filename
  fq1=$fastq_reads/${base}_1P.fastq
  echo "fq1 =" $fq1

  fq2=$fastq_reads/${base}_2P.fastq
  echo "fq2 =" $fq2

  hisat2 \
  -q --rna-strandness R \
  -x HISAT2/hisatGenomes/grch38/genome \
  -1 $fq1 \
  -2 $fq2 \
  | samtools sort -o mappedReads/${base}.bam

done

echo "alignment complete!"