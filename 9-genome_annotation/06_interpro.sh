#!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH --mem=8G
#SBATCH --time=0-0:45:00
#SBATCH --job-name=interpro
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for functional classification of protein sequences from GALBA

# Load modules
module purge
module load InterProScan/5.66-98.0-gimkl-2022aPerl-5.34.1-Python-3.11.3

# Params
PROJECT=$1 #Antipodean or Gibson's albatross

proteins=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA/FILTERED/galba_filtered_cleanstop.aa
out_dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA_interpro
mkdir -p $out_dir

# Run interpro
interproscan.sh \
	-appl pfam \
	--disable-precalc \
	--formats TSV, GFF3 \
	--goterms \
	--iprlookup \
	--pathways \
	--seqtype p \
	--cpu 12 \
	--input $proteins \
	-b $out_dir/GALBA_interpro_output

# -appl allows you to choose which analyses to run. If not specified all analyses will be run
# --disable-precalc disables use of precalculated match lookup service. All match calculations will be run locally. Not entirely sure what this means but can increase accuracy when working with novel sequences (at expense of increased compute time/resource use).
# --goterms switches on lookup of corresponding GO annotation
# --iprlookup Also include lookup of corresponding InterPro annotation in the TSV and GFF3 output formats.
# --pathways switch on lookup of corresponding Pathway annotation

#State: COMPLETED
#Cores: 12
#Tasks: 1
#Nodes: 1
#Job Wall-time:   42.0%  00:25:12 of 01:00:00 time limit
#CPU Efficiency:  46.8%  02:21:37 of 05:02:24 core-walltime ##requesting 24 cpus
#Mem Efficiency:  39.2%  3.92 GB of 10.00 GB
