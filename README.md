# RNASeq_local
Scripts for running rnaseq workflow locally without cloud or high performance computing

These scripts serve as a demonstration for a workflow that could be performed on the cloud or HPC environment with some modifications (resource requests, job steps). The data and analysis produced from this workflow may be useful in pilot studies, where analysis is needed on an experiment before more expenses and resources are devoted towards continuing the investigation

&nbsp; 

The entire workflow can be executed by running rnaSeqPipeline.sh, or seperately in the following order:

[1] getfastq_and_qc.sh  ->
&nbsp; 
[2] callFastp.sh  ->
&nbsp; 
[3] alignToGenome.sh  ->
&nbsp; 
[4] getGeneCounts.sh
&nbsp; 

A detailed description on what each step does can be found in the script

