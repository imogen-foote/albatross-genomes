#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH --mem=350G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=porechop
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for removal of ONT sequencing adapters

# Load modules
module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
LIB=$2 #different library preps
read_dir=/path/to/$PROJECT/raw_data/ont/all_fastq

# Run Porechop
porechop -i $read_dir/$PROJECT.simplex.fastq.gz -o $read_dir/$PROJECT.simplex_trimmed.fastq.gz --threads 40

