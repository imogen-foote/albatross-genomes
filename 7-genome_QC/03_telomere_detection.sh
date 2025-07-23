#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=0-0:05:00
#SBATCH --job-name=quarTeT
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

# Activate conda env
module purge && module load Miniconda3
source $(conda info --base)/etc/profile.d/conda.sh
export PYTHONNOUSERSITE=1

conda activate /nesi/project/vuw03922/quarTeTdependencies

# Set variables
PROJECT=$1 #Antipodean or Gibson's albatross
sample=$2

# Define directories
assembly=/path/to/$PROJECT/data/Chapter3/assemblies/flye/4_nuclear_only/${sample}_q8_h50_nuclear/${sample}_nuclear_sorted_renamed.fasta
out_dir=/path/to/$PROJECT/output/Chapter3/flye_assembly/4_nuclear_only/${sample}_q8_h50_nuclear/${sample}_q8_h50_nuclear_quarTeT
mkdir -p $out_dir

# Set path to python script
quartet=/path/to/quartet.py

## Run quarTeT TeloExplorer
cd $out_dir

python3 $quartet TeloExplorer \
	-i $assembly \
	-c animal \
	-p ${sample}_quarTeT \
	-m 50

# Deactivate conda env
conda deactivate
