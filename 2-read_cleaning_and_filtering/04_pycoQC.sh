#!/bin/bash 
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --time=0-00:5:00
#SBATCH --job-name=pycoqc
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to check quality of raw and cleaned/filtered reads

# Load modules
module purge
module load Python/3.10.5-gimkl-2022a

# Activate conda environment
source /path/to/conda_env
export PYTHONNOUSERSITE=1 #makes sure local packages installed in home folder ~/.local/lib/pythonX.Y/site-packages/ (where X.Y is the Python version, e.g. 3.8) by pip install --user are excluded from your conda environments.

# Params
PROJECT=$1 #Antipodean and Gibson's albatross
LIB=$2 #different library preps

# For Guppy libraries
read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/fastq

# For Dorado libraries
#read_dir=/path/to/$PROJECT/raw_data/ont/$LIB/bam

output_dir=/path/to/$PROJECT/data/Chapter3/pycoQC/

# Run pycoQC
pycoQC -f $read_dir/sequencing_summary*.txt --min_pass_qual 8 -o $output_dir/$LIB.pycoqc_qual8.html
pycoQC -f $read_dir/sequencing_summary*.txt --min_pass_qual 8 --min_pass_len 200 -o $output_dir/$LIB.pycoqc_qual8_len200.html

# Deactivate conda environment
deactivate


# FOR MINION/GUPPY LIBRARIES
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:    1.1%  00:00:41 of 01:00:00 time limit
#CPU Efficiency:  43.9%  00:00:18 of 00:00:41 core-walltime
#Mem Efficiency:  12.4%  253.12 MB of 2.00 GB

# FOR PROMETHION/DORADO LIBRARIES
#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:    9.5%  00:00:57 of 00:10:00 time limit
#CPU Efficiency:  89.5%  00:00:51 of 00:00:57 core-walltime
#Mem Efficiency:  34.5%  1.04 GB of 3.00 GB
