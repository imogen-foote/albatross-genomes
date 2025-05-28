#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=15G
#SBATCH --time=1-0:00:00
#SBATCH --job-name=purge_haplotypes
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to identify and remove haplotigs from de novo genome assembly

# Load modules
module purge
module load minimap2/2.24-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50
ASSEMBLER=$4 #e.g. flye
POLISHER=$5 #e.g. medaka
FASTQ_DIR=/path/to/$PROJECT/data/Chapter3/sequence/ont
POLISHED_DIR=/path/to/$PROJECT/data/Chapter3/assemblies/$ASSEMBLER/2_polished/$SAMPLE'_'$FILTER'_'$POLISHER
PURGE_DIR=/path/to/$PROJECT/data/Chapter3/assemblies/$ASSEMBLER/3_purge_haplotigs/$SAMPLE'_'$FILTER'_purged'
mkdir -p $PURGE_DIR

# Map reads to assembly
minimap2 -ax map-ont $POLISHED_DIR/*.fasta $FASTQ_DIR/*'combined_'$FILTER.fastq.gz | samtools view -b | samtools sort > $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER.bam

# Activate conda environment
module purge
module load Miniconda3
source $(conda info --base)/etc/profile.d/conda.sh
export PYTHONNOUSERSITE=1
conda activate /path/to/conda_env

# Create histogram
cd $PURGE_DIR
module load R/4.3.1-gimkl-2022a
purge_haplotigs hist -b $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER.bam -g $POLISHED_DIR/*.fasta -t 10


# Contig coverage
purge_haplotigs contigcov -i $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER.bam.gencov  -l 10  -m 40  -h 105  [-o $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER'_coverage_stats.csv' -j 80  -s 80 ]

mv coverage_stats.csv $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER'_coverage_stats.csv'

# Purge
purge_haplotigs purge 	-g $POLISHED_DIR/*.fasta 					\
						-c $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER'_coverage_stats.csv' 	\
						-b $PURGE_DIR/$SAMPLE'_'$FILTER'_'$POLISHER.bam						\
						-o $PURGE_DIR/assembly							\
						-t 10

# Deactivate conda environment
conda deactivate


# Create histogram step
#State: COMPLETED
#Cores: 6
#Tasks: 1
#Nodes: 1
#Job Wall-time:   46.7%  16:49:31 of 1-12:00:00 time limit
#CPU Efficiency:  50.1%  2-02:36:38 of 4-04:57:06 core-walltime
#Mem Efficiency:  84.1%  12.62 GB of 15.00 GB

# Contig coverage and purge step
#State: COMPLETED
#Cores: 6
#Tasks: 1
#Nodes: 1
#Job Wall-time:    0.1%  00:01:59 of 2-00:00:00 time limit
#CPU Efficiency:  46.5%  00:05:32 of 00:11:54 core-walltime
#Mem Efficiency:   4.1%  8.14 GB of 200.00 GB
