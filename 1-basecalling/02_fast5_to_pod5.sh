#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=6G
#SBATCH --time=05:00:00
#SBATCH --job-name=fast52pod5
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for conversion of raw ONT data (.fast5) from Kit 14 (SQK-LSK114) library prep/R10.4.1 PromethION sequencing runs to pod5 format in preparation for basecalling

# Load modules
module purge
module load GCCcore/11.3.0
module load Python/3.10.5-gimkl-2022a
module load pod5/0.2.4-gimkl-2022a

# Params
PROJECT=$1 #Antipodean or Gibson's
LIB=$2 #different library preps/sequencing runs
read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/fast5
out_dir=/path/to/$PROJECT/raw_data/ont/$LIB/pod5/

# Run conversion
pod5 convert fast5 $read_dir/fast5_pass/*.fast5 --output $out_dir --one-to-one $read_dir/
pod5 convert fast5 $read_dir/fast5_fail/*.fast5 --output $out_dir --one-to-one $read_dir/

mv $out_dir/fast5_pass/*.pod5 $out_dir
mv $out_dir/fast5_fail/*.pod5 $out_dir


#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   54.6%  02:43:46 of 05:00:00 time limit
#CPU Efficiency: 194.1%  05:17:53 of 02:43:46 core-walltime
#Mem Efficiency:  37.9%  3.79 GB of 10.00 GB
