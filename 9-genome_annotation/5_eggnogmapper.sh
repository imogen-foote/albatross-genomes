!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH --mem=10G
#SBATCH --time=0-2:30:00
#SBATCH --job-name=eggnog
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to run functional annotation of GALBA output

# Load modules
module purge
module load eggnog-mapper/2.1.12-gimkl-2022a

# PARAMS
PROJECT=$1 #Antipodean or Gibson's albatross

dir=/path/to/$PROJECT/data/Chapter3/assemblies/flye/6_gene_annotation
proteins=$dir/GALBA/FILTERED/galba_filtered.aa
gff3=$dir/GALBA/FILTERED/galba_filtered.gff3
out_dir=$dir/GALBA_eggnog
mkdir -p $out_dir

## Run
emapper.py \
	--data_dir $DATA_PATH \
	-i $proteins \
	-o $out_dir/$PROJECT \
	--decorate_gff $gff3 \
	--tax_scope 8782 \
	--cpu 12


#State: COMPLETED
#Cores: 6
#Tasks: 1
#Nodes: 1
#Job Wall-time:   18.0%  00:53:59 of 05:00:00 time limit
#CPU Efficiency: 183.2%  09:53:27 of 05:23:54 core-walltime
#Mem Efficiency:  22.7%  6.81 GB of 30.00 GB
