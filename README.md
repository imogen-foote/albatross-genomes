# Genome assembly of the Antipodean and Gibson's albatrosses (*Diomedea antipodensis antipodensis* and *D. a. gibsoni*)
This repository contains scripts used in genome assembly and annotation for the manuscript:

Foote, I., Oosting, T., Walker, K., Elliott, G., Rexer-Huber, K., Parker, G. C., Chambers, G. K. and Ritchie, P. A. (in prep). Genome assembly of the Antipodean and Gibson's albatrosses (*Diomedea antipodensis antipodensis* and *D. a. gibsoni*).

## Pipeline description

### 1 - Basecalling
* Basecalling of raw ONT data from Kit 12 (SQK-LSK112) library prep/R10.4 MinION sequencing runs (.fast5): [Guppy](https://github.com/nanoporetech/pyguppyclient)*.
* Conversion of raw ONT data (.fast5) from Kit 14 (SQK-LSK114) library prep/R10.4.1 PromethION sequencing runs to pod5 format: [pod5](https://github.com/nanoporetech/pod5-file-format). 
* Basecalling of pod5 files: [Dorado](https://github.com/nanoporetech/dorado)*.
* Conversion of basecalling output (.bam) to .fastq format: [SAMtools](https://github.com/samtools/samtools).
  
\**Note: Both Guppy and Dorado were used as two separate libraries were prepared and sequenced at different times using different chemistries/flow cell types, each compatible with a different basecalling software.*

### 2 - Read cleaning/filtering/QC
* Removal of ONT sequencing adapters: [Porechop](https://github.com/rrwick/Porechop).
* Removal of reads containing ONT DNA Control Sequence: [CLEAN](https://github.com/rki-mf1/clean) workflow.
* Filter to remove reads < Q8 and perform headcrop of 50 bp: [Chopper](https://github.com/wdecoster/chopper).
* Check quality of raw and cleaned/filtered reads: [PycoQC](https://github.com/a-slide/pycoQC); [NanoPlot](https://github.com/wdecoster/NanoPlot).

### 3 - Genome assembly 
* De novo genome assembly: [Flye](https://github.com/mikolmogorov/Flye); [Raven](https://github.com/lbcb-sci/raven).

### 4 - Genome polishing
* Polishing of genome sequence: [Medaka](https://github.com/nanoporetech/medaka) (Flye assembly); [Racon](https://github.com/isovic/racon) (Raven assembly). 

### 5 - Haplotig removal 
* Identify and remove haplotigs: [purge_haplotigs](https://bitbucket.org/mroachawri/purge_haplotigs/src/master/). 

### 6 - Contaminant removal
* Identify and remove foreign contaminant sequences: [NCBI FCS-gx](https://github.com/ncbi/fcs). 

### 7 - Genome QC
* Assess BUSCO completeness of genome: [BUSCO](https://busco.ezlab.org/).
* Evaluate and visualise assembly metrics: [assembly-stats](https://github.com/rjchallis/assembly-stats).
* Identify telomeric repeat sequences: [quarTeT](https://github.com/aaranyue/quarTeT). 

### 8 - Repeat masking
* Identify and softmask repeat regions in the genome: [RepeatModeler](https://github.com/Dfam-consortium/RepeatModeler); [RepeatMasker](https://github.com/Dfam-consortium/RepeatMasker). 

### 9 - Genome annotation
* Perform annotation of genome: [GALBA](https://github.com/Gaius-Augustus/GALBA).
* Filtering of annotation and calculation of summary statistics: [AGAT](https://agat.readthedocs.io/en/latest/index.html).
* Evaluate annotation BUSCO completeness: [BUSCO](https://busco.ezlab.org/).
* Functional annotation: [eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper).
* Functional classification of protein sequences: [InterPro Scan](https://interproscan-docs.readthedocs.io/en/v5/).
* Calculate summary statistics of functional annotation: custom script. 

### 10 - Mitochondrial genome assembly and annotation
* Mapping of reads to *Phoebastria albatrus* mitogenome and removal of unmapped reads: [Minimap2](https://github.com/lh3/minimap2); [SAMtools](https://github.com/samtools/samtools).
* De novo mitogenome assembly using mitochondrial reads: [Flye](https://github.com/mikolmogorov/Flye).
* Annotation of mitogenome: [MITOS2](https://github.com/gavieira/mitos2_wrapper).
* Visualise coverage of mapped reads to mitogenome to check for reads covering duplicated regions and excessively soft-clipped reads: [Geneious Prime](https://www.geneious.com/)†. 

### 11 - Whole genome comparison
* Alignment of whole genome sequence and visualisation with dot-plots: [D-genies](https://dgenies.toulouse.inra.fr/)†; [Minimap2](https://github.com/lh3/minimap2))†.
* Alignment of whole genome sequence and visualisation with circos plot: [Circa](https://circa.omgenomics.com/)†; [Mashmap](https://github.com/marbl/MashMap).

*†Note: these steps were not performed on the command-line, so there are no associated scripts.*

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16350756.svg)](https://doi.org/10.5281/zenodo.16350756)
