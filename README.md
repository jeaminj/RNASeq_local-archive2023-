# RNASeq_local (archive 2023)
Scripts for running a data pre-processing rnaseq workflow locally, without cloud or high performance computing

These scripts serve as a workflow demonstration of pre-processing rnaseq data without the need of cloud or HPC cluster (Given appropriate system specifications). 

&nbsp; 

The entire workflow can be executed by running rnaSeqPipeline.sh, or seperately in the following order:

[1] getfastq_and_qc.sh  ->
[2] callFastp.sh  ->
[3] alignToGenome.sh  ->
[4] getGeneCounts.sh
&nbsp; 



