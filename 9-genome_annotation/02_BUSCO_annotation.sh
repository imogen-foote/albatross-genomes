#!/bin/bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --time=0-1:00:00
#SBATCH --job-name=BUSCO
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to evaluate annotation BUSCO completeness

# Load modules
module purge
module load BUSCO/5.6.1-gimkl-2022a


# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

proteins=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA/galba.aa
out_dir=/path/to/$PROJECT/output/Chapter3/flye_assembly/6_gene_annotation/$SAMPLE'_'$FILTER/$SAMPLE'_'$FILTER'_genes_GALBA.busco'
mkdir -p $out_dir

echo "Run BUSCO"
cd $out_dir

# Run BUSCO
busco 	-i $proteins \
	-o $SAMPLE'_'$FILTER'_genes_GALBA_busco' \
	-l aves_odb10 \
	-m proteins \
	--cpu 10 


# Manual: https://busco.ezlab.org/

#State: COMPLETED
#Cores: 5
#Tasks: 1
#Nodes: 1
#Job Wall-time:   10.4%  00:37:35 of 06:00:00 time limit
#CPU Efficiency: 146.0%  04:34:17 of 03:07:55 core-walltime
#Mem Efficiency:   9.2%  2.75 GB of 30.00 GB
