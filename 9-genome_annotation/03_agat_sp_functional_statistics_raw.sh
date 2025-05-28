#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=0:05:00
#SBATCH --job-name=agat_stats
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to calculate summary statistics of genome annotation (GALBA output)

# Load modules
module purge
module load AGAT/1.0.0-gimkl-2022a-Perl-5.34.1-R-4.2.1

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50
GFF=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA/galba.gff3
AGAT_DIR=/path/to/$PROJECT/output/Chapter3/flye_assembly/6_gene_annotation/$SAMPLE'_'$FILTER/AGAT_stats_GALBA

# Set genome size in order to compute more statistics
if [ $PROJECT = "AntipodeanAlbatross" ]; then
	SIZE=1254625516
elif [ $PROJECT = "GibsonsAlbatross" ]; then
	SIZE=1263156490
else
	echo "Unknown project. Genome size not set."
	exit 1
fi

echo "Project: $PROJECT"
echo "Genome size: $SIZE"


# Create output parent directory NOTE: GALBA creates it's own output directory and will throw an error if the specified output directory already exists, so ensure you specify a subdirectory below for GALBA to create
if [ ! -d $AGAT_DIR ]; then
	mkdir -p $AGAT_DIR
fi

# Run agat
agat_sp_functional_statistics.pl	--gff $GFF \
					--gs $SIZE \
					-o $AGAT_DIR/raw


#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:    4.1%  00:02:26 of 01:00:00 time limit
#CPU Efficiency:  95.2%  00:02:19 of 00:02:26 core-walltime
#Mem Efficiency:  27.3%  1.36 GB of 5.00 GB
