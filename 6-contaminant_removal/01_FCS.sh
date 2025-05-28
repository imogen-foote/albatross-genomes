#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --mem=500G
#SBATCH --time=05:00:00
#SBATCH --job-name=fcs
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to identify foreign contaminant sequences from genome assembly (none were identified)

# Load modules
module purge 
module load Singularity/3.11.3
module load Python/3.11.3-gimkl-2022a

# Params
export FCS_DEFAULT_IMAGE=fcs-gx.sif
PROJECT=$1 #Antipodean or Gibson's albatross 
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50
ASSEMBLER=$4 #e.g. flye
genome=/path/to/$PROJECT/data/Chapter3/assemblies/$ASSEMBLER/3_purge_haplotigs/$SAMPLE'_'$FILTER'_purged'/assembly.fasta 
out_dir=/npath/to/$PROJECT/data/Chapter3/assemblies/$ASSEMBLER/4_FCS/$SAMPLE'_'$FILTER'_FCS'
mkdir $out_dir

# Specify path to FCS-gx database
GXDB_LOC=/path/to/FCS/gxdb

# Test run with test dataset
#python3 ./fcs.py --image fcs-gx.sif screen genome --fasta ./fcsgx_test.fa.gz --out-dir $out_dir --gx-db "$GXDB_LOC/test-only" --tax-id 6973

# Full run with tax-id for 'aves'
python3 ./fcs.py --env-file env.txt --image fcs-gx.sif screen genome --fasta $genome --out-dir $out_dir --gx-db "$GXDB_LOC" --tax-id 8782

cp /path/to/stdout/fcs.$SLURM_JOB_ID.err $out_dir


#State: COMPLETED
#Cores: 24
#Tasks: 1
#Nodes: 1
#Job Wall-time:   24.6%  02:57:07 of 12:00:00 time limit
#CPU Efficiency:   5.5%  03:54:05 of 2-22:50:48 core-walltime
#Mem Efficiency:   0.9%  4.27 GB of 500.00 GB ##but seems to require all 500 to cache the db to memory
