#!/bin/bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=30G
#SBATCH --time=0-10:00:00
#SBATCH --job-name=BUSCO
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to assess BUSCO completeness of genome

# Load modules
module purge
module load BUSCO/5.3.2-gimkl-2020a

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
assembly_name=$2 #sample_filter e.g. blue-45g_q8_h50
assembler=$3 #e.g. flye
assembly=/path/to/$PROJECT/data/Chapter3/assemblies/$assembler/3_purge_haplotigs/$assembly_name/assembly.fasta
out_dir=/path/to/$PROJECT/output/Chapter3/${assembler}_assembly/3_purge_haplotigs/$assembly_name/$assembly_name.busco
mkdir -p $out_dir

echo "Run BUSCO"
cd $out_dir

# run BUSCO
busco 	-i $assembly \
	-o $assembly_name'_busco' \
	-l aves_odb10 \
	-m genome \
	--cpu 10 \
	--restart

# Manual: https://busco.ezlab.org/

#State: COMPLETED
#Cores: 5
#Tasks: 1
#Nodes: 1
#Job Wall-time:   42.6%  05:06:37 of 12:00:00 time limit
#CPU Efficiency: 178.6%  1-21:37:35 of 1-01:33:05 core-walltime
#Mem Efficiency:  30.2%  15.10 GB of 50.00 GB
