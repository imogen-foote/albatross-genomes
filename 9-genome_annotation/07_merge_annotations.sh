#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=0-0:10:00
#SBATCH --job-name=merge_annotation
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to merge output from eggNOG-mapper and InterPro-Scan

# Load modules
module purge
module load AGAT/1.0.0-gimkl-2022a-Perl-5.34.1-R-4.2.1

# Params
PROJECT=$1 #Antipodean or Gibson's albatross

dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation
gff3=$dir/GALBA/FILTERED/galba_filtered.gff3
eggnog=$dir/GALBA_eggnog/$PROJECT.emapper.decorated.gff
interpro=$dir/GALBA_interpro/GALBA_interpro_output.gff3
out_dir=$dir/GALBA/FILTERED


## Description of the agat command: This script merges different gff annotation files into one. 
## It uses the AGAT parser that takes care of duplicated names and fixes other oddities met in those files.
agat_sp_merge_annotations.pl \
	-f $eggnog \
	-f $interpro \
	--out $out_dir/galba_filtered_functional_annotation.gff3


#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   11.1%  00:06:38 of 01:00:00 time limit
#CPU Efficiency:  98.0%  00:06:30 of 00:06:38 core-walltime
#Mem Efficiency:  90.0%  4.50 GB of 5.00 GB
