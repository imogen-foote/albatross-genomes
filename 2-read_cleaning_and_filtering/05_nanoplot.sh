#!/bin/bash 
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=0-2:0:00
#SBATCH --job-name=nanoplot
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to check quality of raw and cleaned/filtered reads

# Load modules
module purge
module load Python/3.10.5-gimkl-2022a

# Activate conda environment
source /path/to/conda_env/bin/activate
export PYTHONNOUSERSITE=1 #makes sure local packages installed in home folder ~/.local/lib/pythonX.Y/site-packages/ (where X.Y is the Python version, e.g. 3.8) by pip install --user are excluded from your conda environments.

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
LIB=$2 #different library preps
read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/fastq
output_dir=/path/to/$PROJECT/data/Chapter3/nanoplot/

# Run NanoPlot
NanoPlot -t 2 --fastq $read_dir/$LIB'_trimmed_clean_filtered_q8_h50.fastq.gz' -o $output_dir/$LIB'_trimmed_clean_filtered_q8_h50'

# Deactivate conda environment
deactivate

# PromethION
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   44.1%  05:17:50 of 12:00:00 time limit
#CPU Efficiency:  99.3%  05:15:46 of 05:17:50 core-walltime
#Mem Efficiency:  52.7%  1.05 GB of 2.00 GB

# MinION
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:    8.4%  00:40:12 of 08:00:00 time limit
#CPU Efficiency:  92.7%  00:37:17 of 00:40:12 core-walltime
#Mem Efficiency:  50.2%  1.00 GB of 2.00 GB
