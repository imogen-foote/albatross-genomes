#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --time=0:05:00
#SBATCH --job-name=mitos
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to annotate genes of mitochondrial genome

# Load modules and conda environment
module purge
module load Miniconda3
source $(conda info --base)/etc/profile.d/conda.sh
export PYTHONNOUSERSITE=1
conda activate /path/to/conda_env

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

read_dir=/path/to/$PROJECT/data/Chapter3/mitogenome/flye_mito_only/$SAMPLE'_'$FILTER'_mito'
ref=/path/to/metazoan_mitos_ref
out_dir=$read_dir/annotated
mkdir $out_dir
cd $out_dir

# Run program
runmitos.py -i $read_dir/$SAMPLE'_mitogenome.fasta' \
	-o $out_dir \
	-c 2 \
	-R $ref \
	-r refseq63m

conda deactivate
