#!/usr/bin/bash

#script configured for paired-end reads

#change working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/rawdata

fastq_reads=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/rawData
genomeindex=/Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/index/starGenome


for base in SRR15852396_GSM5574688_tumor_rep4_Homo_sapiens_RNA-Seq SRR15852426_GSM5574718_normal_rep4_Homo_sapiens_RNA-Seq 
do
  echo $base
  
  #defines fastq_1 and fastq2 file for each base sample read and their path
  fq1=$fastq_reads/${base}_1.fastq
  fq2=$fastq_reads/${base}_2.fastq
  
  STAR \
  --runMode alignReads \
  --genomeDir $genomeindex \
  --outSAMtype BAM SortedByCoordiante \
  --readFilesIn $fq1 $fq2 \
  --runThreadN 4 \
  --outFileNamePrefix ../mappedReads/${base}"_" 

done

echo "alignment complete!"