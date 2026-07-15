#!/bin/bash

# Define path to GTF annotation
GTF="/Users/manuela/Desktop/Project_propsal/annotation/gencode.vM37.annotation.gtf"

# Create output directory if it doesn't exist
mkdir -p stringtie_output

# List of sample BAM files
SAMPLES=(
SRR23340892
SRR23340893
SRR23340894
SRR23340895
SRR23340896
SRR23340897
)

# Loop through samples
for SAMPLE in "${SAMPLES[@]}"
do
  echo "---------------------------------------"
  echo "Running StringTie for $SAMPLE..."
  echo "Started at: $(date)"

  stringtie ${SAMPLE}_sorted.bam \
    -G $GTF \
    -o stringtie_output/${SAMPLE}.gtf \
    -A stringtie_output/${SAMPLE}_gene_abund.tab \
    -e -B -p 4

  echo "$SAMPLE done!"
  echo "Finished at: $(date)"
  echo "---------------------------------------"
done

echo "All transcriptome assemblies completed."

