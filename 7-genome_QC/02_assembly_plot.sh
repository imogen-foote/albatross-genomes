#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=0-0:10:00
#SBATCH --job-name=circle_plot
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## Script to evaluate and visualise assembly metrics (snail plots)

# Load modules
module purge
module load Singularity/3.11.3

# Params
PROJECT=$1 #Antipodean or Gibson's albatross
ASSEMBLY_NAME=$2 #sample_filter e.g. blue-45g_q8_h50
ASSEMBLER=$3 #e.g. flye
ASSEMBLY_FILE=/path/to/$PROJECT/data/Chapter3/assemblies/$ASSEMBLER/3_purge_haplotigs/$ASSEMBLY_NAME/assembly.fasta
out=/path/to/$PROJECT/output/Chapter3/${ASSEMBLER}_assembly/3_purge_haplotigs/$ASSEMBLY_NAME/$ASSEMBLY_NAME.circle_plot
mkdir -p $out
perl=/path/to/circle_plot/pl/asm2stats.pl

# Copy template folder (circle_plot) to output directory
cp -r /path/to/circle_plot/ $out

# Create json file
echo "var ${PROJECT}_${ASSEMBLER} = " > $out/circle_plot/json/${PROJECT}_${ASSEMBLER}.json
perl $perl $ASSEMBLY_FILE >> $out/circle_plot/json/${PROJECT}_${ASSEMBLER}.json
echo "localStorage.setItem('${PROJECT}_${ASSEMBLER}',JSON.stringify(${PROJECT}_${ASSEMBLER}))" >> $out/circle_plot/json/${PROJECT}_${ASSEMBLER}.json

# Add json to html
sed -i s"%<!--add_jsons_here-->%  <!--add_jsons_here-->\n  <script type=\"text/javascript\" src=\"json/${PROJECT}_${ASSEMBLER}.json\"></script>%"g $out/circle_plot/assembly-stats.html


#State: COMPLETED
#Cores: 1
#Tasks: 1
#Nodes: 1
#Job Wall-time:    5.0%  00:03:01 of 01:00:00 time limit
#CPU Efficiency: 100.0%  00:03:01 of 00:03:01 core-walltime
#Mem Efficiency:  40.4%  4.04 GB of 10.00 GB
