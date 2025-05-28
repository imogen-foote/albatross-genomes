#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --time=0:10:00
#SBATCH --job-name=mashmap
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script for alignment of whole genomes for input to Circa https://circa.omgenomics.com/

# Load modules
module purge
module load MashMap/3.0.4-Miniconda3

# Params
antipodean=/path/to/genome1.fasta
gibsons=/path/to/genome2.fasta
out_dir=/path/to/output
mkdir -p $out_dir
cd $out_dir


#### Compute table ####
##### You'll need to adjust seq_length and perc_identity to your sepecific case - more strict as evolutionary relatedness increases. The trade-off 
##### will be reduing off-target hits/noise while ensuring information is not lost.

	mashmap -r $gibsons \
	-q $antipodean \
	--segLength 50000 \
	--perc_identity 95 \
	--kmer 16

#tried both 90 and 95 per_identity and dotplots almost exactly the same

#### Convert space into tab delimited and add header for table ####
	sed -e 's/ /\t/g' mashmap.out > mashmap.out.table
	sed -i '1 i\query\tlength\t0_based_start\tq_end\tstrand\tref\tlength\tstart\tr_end\tidentity' mashmap.out.table
