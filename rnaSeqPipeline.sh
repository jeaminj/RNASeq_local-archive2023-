#!/bin/bash

SECONDS=0

#set working directory
cd /Users/jeamin/Documents/bioinfo/bc_tissue_rnaSeq/

# Step [1]: Quality Control with fastqc
fastqc rawData/*.fastq -o rawData/

# Step [2]: Trimming with trimmomatic
trimmomatic PE \
-threads 4 \
-phred33 \
-trimlog trimmedData/SRR15852396_tumor_trimmed.log \
rawData/SRR15852396_1.fastq rawData/SRR15852396_2.fastq \
-baseout trimmedData/SRR15852396_tumor.fastq \
ILLUMINACLIP:adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 MINLEN:36  

echo "Trimmomatic completed on tumor sequences, starting trimming on normal!"

trimmomatic PE \
-threads 4 \
-phred33 \
-trimlog trimmedData/SRR15852426_normal_trimmed.log \
rawData/SRR15852426_1.fastq rawData/SRR15852426_2.fastq \
-baseout trimmedData/SRR15852426_normal.fastq \
ILLUMINACLIP:adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 MINLEN:36 

echo "Trimmomatic completed on normal sequences, starting qc on trimmed data"

# Step [2.5]: quality checking the now trimmed data
fastqc trimmedData/*.fastq -o trimmedData/
echo "QC on trimmed data complete, begginning alignment!"

# Step [3]: Aligning to genome with HISAT2
# download genome index
# wget https://genome-idx.s3.amazon.aws.com/hisat/grch38_genome.tar.gz (variable to updates)

# run alignment with hisat2
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

# Step [4] Quantification with featureCounts
# download annotation gtf file
# wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz (variable to updates)
featureCounts -s 2 -a index/Homo_sapiens.GRCh38.109.gtf -o quants/SRR15852396_tumor_featureCounts.txt mappedReads/SRR15852396_tumor.bam
featureCounts -S 2 -a index/Homo_sapiens.GRCh38.109.gtf -o quants/SRR15852426_normal_featureCounts.txt mappedReads/SRR15852426_normal_.bam

duration=SECONDS
echo "$((duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
