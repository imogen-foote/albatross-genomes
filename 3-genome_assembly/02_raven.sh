#!/bin/bash
#SBATCH --cpus-per-task=20
#SBATCH --mem=70G
#SBATCH --time=0-15:0:00
#SBATCH --job-name=raven
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for de novo genome assembly with ONT reads using the Raven assembly algorithm

# Load modules
module purge
module load Raven/1.5.0-GCC-9.2.0

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #individual that reference sample came from
FILTER=$3 #q8_h50
read_dir=/path/to/$PROJECT/data/Chapter3/sequence/ont
output_dir=/path/to/$PROJECT/data/Chapter3/assemblies/raven/1_raw

mkdir -p $output_dir/$SAMPLE'_'$FILTER
cd $output_dir/$SAMPLE'_'$FILTER

# Run Raven
raven -t 20 $read_dir/*'_combined_'$FILTER.fastq.gz > $output_dir/$SAMPLE'_'$FILTER/assembly.fasta


#State: COMPLETED
#Cores: 10
#Tasks: 1
#Nodes: 1
#Job Wall-time:   96.6%  14:29:07 of 15:00:00 time limit
#CPU Efficiency: 160.9%  9-17:02:26 of 6-00:51:10 core-walltime
#Mem Efficiency:  75.3%  52.72 GB of 70.00 GB
