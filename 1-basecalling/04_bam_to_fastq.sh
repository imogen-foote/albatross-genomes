#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=50MB
#SBATCH --time=6:00:00
#SBATCH --job-name=bam2fastq
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to convert Dorado basecalling output (.bam) to .fastq format

# Load modules
module purge
module load SAMtools/1.16.1-GCC-11.3.0

# Params
PROJECT=$1 #Antipodean or Gibson's
LIB=$2 #different library preps
read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/bam
out_dir=/path/to/$PROJECT/raw_data/ont/$LIB/fastq

# Run conversion
samtools fastq $read_dir/$LIB.calls.bam > $out_dir/$LIB.fastq
bgzip $out_dir/$LIB.fastq


#State: COMPLETED
#Cores: 2
#Tasks: 1
#Nodes: 1
#Job Wall-time:   76.6%  02:17:53 of 03:00:00 time limit
#CPU Efficiency:  50.0%  02:17:49 of 04:35:46 core-walltime *(4 cpus requested)*
#Mem Efficiency:   0.1%  11.14 MB of 8.00 GB
