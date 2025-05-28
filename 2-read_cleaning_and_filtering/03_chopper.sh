#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH --mem=50MB
#SBATCH --time=0-2:00:00
#SBATCH --job-name=chopper
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to quality filter reads and perform headcrop

# Load modules
module purge
module load chopper/0.5.0-GCC-11.3.0

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
LIB=$2 #different library preps
read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/fastq

# Run chopper to filter out low quality reads and perform headcrop
gunzip -c $read_dir/$LIB'_trimmed_clean.fastq.gz' | chopper -q 8 --headcrop 50 --threads 8 | gzip > $read_dir/$LIB'_trimmed_clean_filtered_q8_h50.fastq.gz' 

# MinION lib
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   42.6%  00:51:04 of 02:00:00 time limit
#CPU Efficiency: 138.5%  01:10:43 of 00:51:04 core-walltime
#Mem Efficiency:   0.6%  2.75 MB of 500.00 MB

# PromethION lib
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   86.6%  12:59:40 of 15:00:00 time limit
#CPU Efficiency: 139.7%  18:08:55 of 12:59:40 core-walltime
#Mem Efficiency:  11.3%  5.66 MB of 50.00 MB
