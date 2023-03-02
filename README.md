# RNASeq_local
Scripts for running rnaseq workflow locally without the need for high performance computing

Although a count matrix file is produced from this workflow (fastq -> featureCounts), only 2 samples and no replicates were used, and thus there are no replicates for actual differential gene expression analysis. Due to computing and storage limitations of running rnaSeq locally, these scripts serve as outlines for a workflow that could be performed on a HPC environment with some modifications (resource requests, job steps). This local workflow and data produced may still be useful in cases where analysis is needed on an experiment run without replicates (perhaps a pilot hypothesis/investigation)  

Note: STAR cannot locally be used for alignment without significant more storage and memory than below


System specifications:

macOS Monterey 12.6.3

1.6 GHz Dual-Core Intel Core i5

8 GB of Memory

~100 GB of Storage
