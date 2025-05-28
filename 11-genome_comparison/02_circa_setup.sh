#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=500MB
#SBATCH --time=0:05:00
#SBATCH --job-name=circa
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to set up file for input to Circa (to make circos plot), from mashmap output

# Load modules
module purge
module load SAMtools/1.16.1-GCC-11.3.0

# Params
antipodean=/path/to/antipodean/genome/dir
gibsons=/path/to/gibsons/genome_dir
out_dir=/path/to/output

# Generate genome index files
samtools faidx $antipodean/assembly.fasta 
cp $antipodean/assembly.fasta.fai $out_dir/antipodean.fasta.fai
samtools faidx $gibsons/assembly.fasta
cp $gibsons/assembly.fasta.fai $out_dir/gibsons.fasta.fai

# Add a header
cat <(echo -e "chromosome\tsize\tnot_needed1\tnot_needed2\tnot_needed3") $out_dir/antipodean.fasta.fai > $out_dir/antipodean_circa.tsv
cat <(echo -e "chromosome\tsize\tnot_needed1\tnot_needed2\tnot_needed3") $out_dir/gibsons.fasta.fai > $out_dir/gibsons_circa.tsv

# Need to rename contig_X, scaffold_X to gibsons_X and antipodean_X so unique identifiers for each genome
#in .tsv files
awk 'BEGIN{FS=OFS="\t"} {sub(/^contig_/, "gibsons_", $1)}1' $out_dir/gibsons_circa.tsv | \
awk 'BEGIN{FS=OFS="\t"} {sub(/^scaffold_/, "gibsons_", $1)}1' > $out_dir/gibsons_circa.tsv

awk 'BEGIN{FS=OFS="\t"} {sub(/^contig_/, "antipodean_", $1)}1' $out_dir/antipodean_circa.tsv | \
awk 'BEGIN{FS=OFS="\t"} {sub(/^scaffold_/, "antipodean_", $1)}1' > $out_dir/antipodean_circa.tsv

# Iin mashmap table
awk 'BEGIN{FS=OFS="\t"} {sub(/^contig_/, "gibsons_", $1)}1' $out_dir/mashmap.out.table | \
awk 'BEGIN{FS=OFS="\t"} {sub(/^scaffold_/, "gibsons_", $1)}1' | \
awk 'BEGIN{FS=OFS="\t"} {sub(/^contig_/, "antipodean_", $6)}1' | \
awk 'BEGIN{FS=OFS="\t"} {sub(/^scaffold_/, "antipodean_", $1)}1' > $out_dir/mashmap.out.table
