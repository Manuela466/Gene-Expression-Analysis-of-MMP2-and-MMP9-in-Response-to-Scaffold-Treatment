#!/bin/bash

# Define genome index path (adjust if needed)
HISAT2_INDEX="/Users/manuela/Desktop/Project_propsal/hisat2_index/mm10/genome"

# List of sample IDs
SAMPLES=(
#SRR23340892
#SRR23340893
#SRR23340894
SRR23340895
SRR23340896
SRR23340897
)

# Loop through all samples
for SAMPLE in "${SAMPLES[@]}"
do
  echo "-------------------------------------------"
  echo "Aligning $SAMPLE..."
  start_time=$(date)

  # Run HISAT2 using FASTQ files from raw_fastq folder
  hisat2 -x $HISAT2_INDEX \
    -1 raw_fastq/${SAMPLE}_1.fastq \
    -2 raw_fastq/${SAMPLE}_2.fastq \
    -S ${SAMPLE}.sam \
    --summary-file ${SAMPLE}_hisat2_summary.txt

  # Convert SAM → BAM
  samtools view -bS ${SAMPLE}.sam > ${SAMPLE}.bam

  # Sort BAM
  samtools sort ${SAMPLE}.bam -o ${SAMPLE}_sorted.bam

  # Index BAM
  samtools index ${SAMPLE}_sorted.bam

  # Clean up
  rm ${SAMPLE}.sam ${SAMPLE}.bam

  end_time=$(date)
  echo "$SAMPLE done!"
  echo "Started: $start_time"
  echo "Ended:   $end_time"
  echo "-------------------------------------------"
done

echo "All alignments completed."


