#!/bin/bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=220G
#SBATCH --time=4-00:0:00
#SBATCH --job-name=flye
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for de novo genome assembly with ONT reads using the Flye assembly algorithm

# Load modules
module purge
module load Flye/2.9.1-gimkl-2022a-Python-3.10.5

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #individual that reference sample came from
FILTER=$3 #q8_h50
read_dir=/path/to/$PROJECT/raw_data/ont/*/fastq
output_dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/1_raw

# Run Flye
flye	--nano-hq $read_dir/*$FILTER.fastq.gz \
	--out-dir $output_dir/$SAMPLE'_'$FILTER \
	--genome-size 1.2g \
	--threads 10 \
	--read-error 0.03  \
	--scaffold \
	--no-alt-contigs 
#	--resume


#State: COMPLETED
#Cores: 5
#Tasks: 1
#Nodes: 1
#Job Wall-time:   43.1%  1-07:00:23 of 3-00:00:00 time limit
#CPU Efficiency: 179.0%  11-13:31:28 of 6-11:01:55 core-walltime
#Mem Efficiency:  59.7%  179.04 GB of 300.00 GB
