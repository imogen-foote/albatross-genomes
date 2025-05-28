#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=12:00:00
#SBATCH --job-name=mitofilter
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to filter mitochondrial reads from nuclear reads for mitogenome assembly

# Load modules
module purge
module load minimap2/2.24-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

read_dir=/path/to/$PROJECT/data/Chapter3/sequence/ont
reads=$read_dir/$SAMPLE'_combined_'$FILTER.fastq.gz
ref_mito=/path/to/Phoebastria_albatrus_mitogenome/mitochondrial_sequence.fasta

# Map reads to ref mitogenome
minimap2 -ax map-ont -t 4 $ref_mito "$reads" > $read_dir/mapped_reads.sam

# Convert SAM to BAM
samtools view -b -o $read_dir/mapped_reads.bam $read_dir/mapped_reads.sam

# Check if the mapping step was successful
if [ $? -eq 0 ]; then
    # Separate mitochondrial and nuclear reads - -F 4 exludes unmapped reads (leaving only mito) and -f 4 excludes mapped reads (leaving only nuclear)
    samtools view -h -b -F 4 $read_dir/mapped_reads.bam > $read_dir/mitochondrial_reads_$FILTER.bam
    samtools view -h -b -f 4 $read_dir/mapped_reads.bam > $read_dir/nuclear_reads_$FILTER.bam

    # Clean up intermediate files
    rm $read_dir/mapped_reads.bam $read_dir/mapped_reads.sam

    echo "Mitochondrial reads extraction and filtering completed."

    # Convert BAM to compressed FASTQ
    samtools fastq $read_dir/mitochondrial_reads_$FILTER.bam | bgzip > $read_dir/mitochondrial_reads_$FILTER.fastq.gz
    samtools fastq $read_dir/nuclear_reads_$FILTER.bam | bgzip > $read_dir/nuclear_reads_$FILTER.fastq.gz

else
    echo "Error in read mapping step. Exiting."
    exit 1
fi


