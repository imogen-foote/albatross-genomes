#!/bin/bash
#SBATCH --cpus-per-task=10 
#SBATCH --mem=25G
#SBATCH --time=4-0:00:00
#SBATCH --job-name=medaka
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for polishing Flye genome assembly 
# Note: uses only reads from libraries sequenced using Kit14 chemistry/PromethION flow cell as different chemistries run with different models, but running both lead to 'overpolishing' (https://github.com/nanoporetech/medaka/issues/330) 

# Load modules 
module purge
module load Miniconda3

# Activate conda environment
source $(conda info --base)/etc/profile.d/conda.sh
export PYTHONNOUSERSITE=1
conda activate /path/to/conda_env

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
assembly=$2 #e.g. blue-45G_q8_h50
sample=$3 #e.g. antipodean_sa52* or gibsons_d36*
filter=$4 #e.g. filtered_q8_h50
#NPROC=$(nproc)#prints the number of processing units available to the current process

draft=/path/to/$PROJECT/data/Chapter3/assemblies/flye/1_raw/$assembly/assembly.fasta
out_dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/2_polished/$assembly'_medaka_1'

mkdir -p $out_dir/tmp_fastq
cp /path/to/$PROJECT/raw_data/ont/$sample'_lib5'/fastq/$sample*$filter.fastq.gz $out_dir/tmp_fastq
cp /path/to/$PROJECT/raw_data/ont/$sample'_lib6'/fastq/$sample*$filter.fastq.gz $out_dir/tmp_fastq
cat $out_dir/tmp_fastq/*.fastq.gz | gunzip -c > $out_dir/tmp_fastq/combined.reads.fastq

# Copy assembly file to tmp dir as advised at https://github.com/nanoporetech/medaka/issues/476#issuecomment-1830214360
cp $draft $out_dir/tmp_fastq

# Run Medaka
medaka_consensus -d $out_dir/tmp_fastq/assembly.fasta \
	-i $out_dir/tmp_fastq/combined.reads.fastq \
	-o $out_dir \
	-m r1041_e82_400bps_sup_v4.1.0
#	-t ${NPROC} \

#rm -r $out_dir/tmp_fastq  

# Deactivate conda environment
conda deactivate


#State: COMPLETED
#Cores: 5
#Tasks: 1
#Nodes: 1
#Job Wall-time:   34.7%  1-17:38:12 of 5-00:00:00 time limit
#CPU Efficiency:  20.8%  1-19:22:07 of 8-16:11:00 core-walltime
#Mem Efficiency:  53.3%  13.32 GB of 25.00 GB
