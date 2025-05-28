#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --mem=80g
#SBATCH --time=1-12:0:0
#SBATCH --job-name=galba
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Perform genome annotation

# Load modules
module purge
module load Apptainer/1.3.1

# Params
PROJECT=$1 #Antipodean or Gibson's alabtross 
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*

export GALBA_SIF=/path/to/galba.sif
export AUGUSTUS_CONFIG_PATH=/path/to/augustus_config/config

##NOTE: use softmasked genome as GALBA always treats genomes as softmasked for repeats
protein=/path/to/protein_db/simplified_combined_bird.faa #see below
genome=/path/to/$PROJECT/data/Chapter3/assemblies/flye/5_repeat_masking/$SAMPLE'_q8_h50_masked'/$SAMPLE'_softmasked_longest65.fasta'
out_dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation
mkdir $out_dir
cd $out_dir

### SOURCING PROTEIN EVIDENCE
## For proteins, GALBA doesn't use large sequence databases like BRAKER does
## Instead use a protein sequences from an annotation of one or many related species

# I got annotations from 4 species, Hydrobates tethys, Calonectris borealis, Pygoscelis papua and Gallus gallus and concatenated
# https://github.com/Gaius-Augustus/GALBA/issues/28 some information about choice of protein input
# simplified the concatenated file using the below code, one species at a time
# sed -e '/^>.*Pygoscelis papua/s/^>\([^ ]*\).*/>\1_Pygoscelispapua/' simplifed_combined_bird3.faa > simplifed_combined_bird4.faa


# Execute
singularity exec $GALBA_SIF galba.pl --species=$PROJECT --genome=$genome \
	--prot_seq=$protein \
	--threads=48 \
	--disable_diamond_filter \
	--AUGUSTUS_CONFIG_PATH=/path/to/augustus_config/config \
	--gff3

# Use --disable_diamond_filter if you do not trust the protein donor, or if the donor is rather distantly related


#State: COMPLETED
#Cores: 24
#Tasks: 1
#Nodes: 1
#Job Wall-time:   56.4%  1-03:04:15 of 2-00:00:00 time limit
#CPU Efficiency: 124.8%  33-18:49:14 of 27-01:42:00 core-walltime
#Mem Efficiency:  53.0%  63.63 GB of 120.00 GB
