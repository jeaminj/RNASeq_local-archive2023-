# RNASeq_local
Scripts for running rnaseq workflow locally without cloud or high performance computing

These scripts serve as a workflow demonstration of pre-processing rnaseq data that can also be executed on the cloud or HPC environment with some modifications (resource requests, job steps). Although the data and analysis produced from this workflow lack high replicate counts, it may be useful in pilot studies, where analysis is needed on an experiment before more resources are devoted towards continuing the investigation. 

&nbsp; 

The entire workflow can be executed by running rnaSeqPipeline.sh, or seperately in the following order:

[1] getfastq_and_qc.sh  ->
[2] callFastp.sh  ->
[3] alignToGenome.sh  ->
[4] getGeneCounts.sh
&nbsp; 

A detailed description on what each step does can be found in the script. Supplemental guide can be found on https://jeaminsblog.com/

