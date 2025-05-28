#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --time=0:05:00
#SBATCH --job-name=functional_stats
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to calculate functional annotation statistics from GFF3 file

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
SAMPLE=$2 #e.g. antipodean_sa52* or gibsons_d36*
FILTER=$3 #e.g. filtered_q8_h50

GFF=/npath/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation/GALBA/FILTERED/galba_filtered_functional_annotation.gff3
out_dir=/path/to/$PROJECT/output/Chapter3/flye_assembly/6_gene_annotation/$SAMPLE'_'$FILTER/functional_stats_GALBA

# Create output  directory 
if [ ! -d $out_dir ]; then
	mkdir -p $out_dir
fi

# Total annotated genes (count unique gene IDs)
total_genes=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="gene" {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l)

# Count genes with features
genes_with_go=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" && $9 ~ /em_GOs=[^;]*/ {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l) 
genes_with_ec=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" && $9 ~ /em_EC=[^;]*/ {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l)
genes_with_kegg=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" && $9 ~ /em_KEGG_Pathway=[^;]*/ {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l) 
genes_with_ko=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" && $9 ~ /em_KEGG_ko=[^;]*/ {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l) 
genes_with_pfam=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" && $9 ~ /em_PFAMs=[^;]*/ {print $9}' | grep -o 'ID=[^;]*' | cut -d'=' -f2 | sort -u | wc -l)

# Unique features
unique_go_terms=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" {print $9}' | grep -o 'em_GOs=[^;]*' | cut -d'=' -f2 | tr ',' '\n' | sort -u | wc -l) 
unique_ec_numbers=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" {print $9}' | grep -o 'em_EC=[^;]*' | cut -d'=' -f2 | tr ',' '\n' | sort -u | wc -l) 
unique_kegg_paths=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" {print $9}' | grep -o 'em_KEGG_Pathway=[^;]*' | cut -d'=' -f2 | tr ',' '\n' | sort -u | wc -l) 
unique_ko_terms=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" {print $9}' | grep -o 'em_KEGG_ko=[^;]*' | cut -d'=' -f2 | tr ',' '\n' | sort -u | wc -l) 
unique_pfam_domains=$(grep -v "^#" "$GFF" | awk -F'\t' '$3=="mRNA" {print $9}' | grep -o 'em_PFAMs=[^;]*' | cut -d'=' -f2 | tr ',' '\n' | sort -u | wc -l)

# Print summary
echo "Annotation Summary for $GFF" > $out_dir/functional_stats_summary.txt 
echo "----------------------------------" >> $out_dir/functional_stats_summary.txt 
echo "Total Annotated Genes: $total_genes" >> $out_dir/functional_stats_summary.txt 
echo "Genes with GO Terms: $genes_with_go" >> $out_dir/functional_stats_summary.txt 
echo "Genes with EC Numbers: $genes_with_ec" >> $out_dir/functional_stats_summary.txt 
echo "Genes with KEGG Pathways: $genes_with_kegg" >> $out_dir/functional_stats_summary.txt 
echo "Genes with KO Terms: $genes_with_ko" >> $out_dir/functional_stats_summary.txt 
echo "Genes with PFAM Domains: $genes_with_pfam" >> $out_dir/functional_stats_summary.txt 
echo "Unique GO Terms: $unique_go_terms" >> $out_dir/functional_stats_summary.txt 
echo "Unique EC Numbers: $unique_ec_numbers" >> $out_dir/functional_stats_summary.txt 
echo "Unique KEGG Pathways: $unique_kegg_paths" >> $out_dir/functional_stats_summary.txt 
echo "Unique KO Terms: $unique_ko_terms" >> $out_dir/functional_stats_summary.txt
echo "Unique PFAM Domains: $unique_pfam_domains" >> $out_dir/functional_stats_summary.txt
