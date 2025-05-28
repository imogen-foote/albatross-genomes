#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=0-0:10:00
#SBATCH --job-name=agat_stats
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to filter annotation output from GALBA

# Lad modules
module purge
module load AGAT/1.0.0-gimkl-2022a-Perl-5.34.1-R-4.2.1

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

GALBA=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA
GFF=$GALBA/galba.gff3
FILTERED=$GALBA/FILTERED
mkdir -p $FILTERED

AGAT_DIR=/path/to/$PROJECT/output/Chapter3/flye_assembly/6_gene_annotation/$SAMPLE'_'$FILTER/AGAT_stats_GALBA
GENOME=/path/to/$PROJECT/data/Chapter3/assemblies/flye/5_repeat_masking/$SAMPLE'_q8_h50_masked'/$SAMPLE'_softmasked_longest65.fasta'

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



# Step 1: Flag Premature Stop Codons
agat_sp_flag_premature_stop_codons.pl \
	 --gff $GFF \
	 --fasta $GENOME \
	 --out $FILTERED/premature_stop_codons_removed.gff3

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_flag_premature_stop_codons.pl"
    exit 1
fi


# Step 2: Filter by ORF Size
agat_sp_filter_by_ORF_size.pl \
	--gff $FILTERED/premature_stop_codons_removed.gff3 \
	--test ">=" \
	--size 50 \
	--output $FILTERED/filtered_by_ORF_size_50aa.gff3

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_filter_by_ORF_size.pl"
    exit 1
fi


# Step 3: Filter Incomplete Gene Coding Models
agat_sp_filter_incomplete_gene_coding_models.pl \
	--gff $FILTERED/filtered_by_ORF_size_50aa3_sup=50.gff \
	--fasta $GENOME \
	--out $FILTERED/filter_incomplete_genes.gff3

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_filter_incomplete_gene_coding_models.pl"
    exit 1
fi


# Step 4: Filter Genes by Length
agat_sp_filter_gene_by_length.pl \
	--gff $FILTERED/filter_incomplete_genes.gff3 \
	--test ">=" \
	--size 50 \
	--output $FILTERED/galba_filtered.gff3
if [ $? -ne 0 ]; then
    echo "Error in agat_sp_filter_gene_by_length.pl"
    exit 1
fi


# Step 5: Keep Longest Isoform -- optional
agat_sp_keep_longest_isoform.pl \
	--gff $FILTERED/filter_incomplete_genes.gff3 \
	--output $FILTERED/galba_filtered_longest_isoform.gff3

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_keep_longest_isoform.pl"
    exit 1
fi


# Generate statistics for the final cleaned annotations 
agat_sp_functional_statistics.pl \
	--gff $FILTERED/galba_filtered.gff3 \
	-gs $SIZE \
	--output $AGAT_DIR/filtered

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_statistics.pl"
    exit 1
fi

# For longest isoform only
agat_sp_functional_statistics.pl \
	--gff $FILTERED/galba_filtered_longest_isoform.gff3 \
	--gs $SIZE \
	--output $AGAT_DIR/filtered_longest_isoform
if [ $? -ne 0 ]; then
	echo "Error in agat_sp_statistics.pl"
	exit 1
fi


# Extract filtered coding sequences
agat_sp_extract_sequences.pl \
	--gff $FILTERED/galba_filtered.gff3 \
	--fasta $GENOME \
	--output $FILTERED/galba_filtered.codingseq

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_extract_sequences.pl codingseq" >&2
    exit 1
fi


# Extract filtered aa sequences
agat_sp_extract_sequences.pl \
	--gff $FILTERED/galba_filtered.gff3 \
	--fasta $GENOME \
	--protein
	--output $FILTERED/galba_filtered.aa

if [ $? -ne 0 ]; then
    echo "Error in agat_sp_extract_sequences.pl aa" >&2
    exit 1
fi


agat_sp_extract_sequences.pl \
	--gff $FILTERED/galba_filtered_longest_isoform.gff3 \
	--fasta $GENOME \
	--protein \
	--output $FILTERED/galba_filtered_longest_isoform.aa
if [ $? -ne 0 ]; then
    echo "Error in agat_sp_extract_sequences.pl longest isoform aa" >&2
    exit 1
fi


# Extract filtered aa sequences with stop codons removed (causes issues for interpro)
agat_sp_extract_sequences.pl \
	--gff $FILTERED/galba_filtered.gff3 \
	--fasta $GENOME \
	--protein \
	--clean_final_stop \
	--output $FILTERED/galba_filtered_cleanstop.aa
if [ $? -ne 0 ]; then
    echo "Error in agat_sp_extract_sequences.pl aa" >&2
    exit 1
fi


mv *.log $FILTERED

# THEN RE-RUN BUSCO


#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:   66.3%  00:29:49 of 00:45:00 time limit
#CPU Efficiency:  99.5%  00:29:40 of 00:29:49 core-walltime
#Mem Efficiency:  60.8%  2.43 GB of 4.00 GB
