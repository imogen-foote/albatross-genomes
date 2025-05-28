#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --time=0:10:00
#SBATCH --job-name=qc_mito
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to map reads back to mitochondrial genome to check coverage etc. 

# Load modules
module purge
module load minimap2/2.24-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

read_dir=/path/to/$PROJECT/data/Chapter3/sequence/ont
reads=$read_dir/'mitochondrial_reads_'$FILTER.fastq.gz
mito_dir=/path/to/$PROJECT/data/Chapter3/mitogenome/flye_mito_only/$SAMPLE'_'$FILTER'_mito'
mitogenome=$mito_dir/$SAMPLE'_mitogenome.fasta'

mkdir -p $mito_dir/QC/aligned
mkdir -p $mito_dir/QC/coverage

# Map reads to assembled mitochondrial genome using minimap2
echo "Mapping reads to mitochondrial genome..."
minimap2 -ax map-ont $mitogenome $reads > $mito_dir/QC/aligned/aligned_reads.sam

# Convert SAM to BAM, sort, and index the BAM file
echo "Converting SAM to BAM, sorting, and indexing..."
samtools view -Sb $mito_dir/QC/aligned/aligned_reads.sam | samtools sort -o $mito_dir/QC/aligned/aligned_reads.sorted.bam
samtools index $mito_dir/QC/aligned/aligned_reads.sorted.bam

# Check the depth/coverage of the mitochondrial genome
echo "Checking depth/coverage of mitochondrial genome..."
samtools depth $mito_dir/QC/aligned/aligned_reads.sorted.bam > $mito_dir/QC/coverage/coverage.txt

# Then visualise .bam file in Geneious to check even coverage, presence of reads that span duplicated regions and no excessively soft-clipped reads


# Clean up SAM file
echo "Cleaning up SAM file..."
rm $mito_dir/QC/aligned/aligned_reads.sam

echo "Mapping and coverage analysis complete. Results saved in $mito_dir/QC"
