#!/bin/bash

# Create output directory
mkdir -p counts

# Define path to GTF
GTF="annotation/gencode.vM37.annotation.gtf"

# Run featureCounts in paired-end mode
featureCounts -T 4 -p \
  -a annotation/gencode.vM37.annotation.gtf \
  -o counts/gene_counts.txt \
  -g gene_name -t exon \
  aligned_bam/*_sorted.bam