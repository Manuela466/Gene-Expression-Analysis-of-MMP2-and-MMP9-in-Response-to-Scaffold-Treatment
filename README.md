# Gene Expression Analysis of MMP2 and MMP9 in Response to Scaffold Treatment

An RNA-seq analysis examining how ion-modified calcium phosphate scaffolds influence **Mmp2** and **Mmp9** gene expression in mouse macrophages.

## Access the Presentation and Report

- [View the PowerPoint Presentation](Research_question.pptx)
- [View the Final Report](BIOI621 Final Report.pdf)

---

## Overview

This project investigates how macrophage **Mmp2** and **Mmp9** expression changes in response to zinc-based calcium phosphate scaffolds with different ion modifications. These genes encode matrix metalloproteinases involved in extracellular matrix degradation, inflammation, tissue remodeling, wound healing, and blood vessel formation.

Using publicly available RNA-seq data from RAW264.7 mouse macrophages, we processed and analyzed gene expression across three scaffold treatment conditions. The workflow included sequence quality assessment, read alignment, transcript assembly, gene-expression quantification, data cleaning, and visualization.

The results showed that **Mmp9 expression was highest in macrophages exposed to the zinc-based CaP scaffold**, suggesting a stronger inflammatory or tissue-remodeling response. In contrast, **Mmp2 was not detectably expressed under any scaffold condition**.

---

## Research Question

How does macrophage **Mmp2** and **Mmp9** expression vary in response to zinc-based calcium phosphate scaffolds with different ion modifications?

---

## Goal of the Study

- Investigate how ion-modified biomaterials influence macrophage gene expression.
- Compare **Mmp2** and **Mmp9** expression across three scaffold treatments.
- Explore how scaffold composition may affect inflammation, tissue remodeling, and immune regulation.
- Build a reproducible RNA-seq workflow for gene-level expression analysis.

---

## Dataset

- **Data source:** NCBI Gene Expression Omnibus
- **Accession:** GSE224524
- **Organism:** *Mus musculus*
- **Cell line:** RAW264.7 macrophages
- **Number of samples:** 6
- **Replicates:** 2 biological replicates per scaffold treatment

### Scaffold Treatments

1. **CaP Zn**  
   Zinc-based calcium phosphate scaffold

2. **CaP Zn0.8Mn**  
   Zinc-based scaffold containing 0.8% manganese

3. **CaP Zn0.8Mn0.1Li**  
   Zinc-based scaffold containing 0.8% manganese and 0.1% lithium

---

## Workflow

1. Data download
2. Quality control
3. Read alignment
4. SAM/BAM file processing
5. Transcript assembly and annotation
6. Gene-expression quantification
7. Data cleaning and filtering
8. Expression visualization
9. Biological interpretation

---

## Tools and Technologies

### Data Download

- **SRA Toolkit**
- **fasterq-dump**

### Quality Control

- **FastQC**
- **MultiQC**

### Read Alignment and File Processing

- **HISAT2**
- **STAR**
- **SAMtools**

### Transcript Assembly and Quantification

- **StringTie**
- **GENCODE vM37 mouse annotation**
- **mm10 mouse reference genome**

### Data Analysis and Visualization

- **R**
- **dplyr**
- **ggplot2**

---

## Methods

### Data Download and Quality Control

Six paired-end RNA-seq samples were downloaded from the NCBI Sequence Read Archive using `fasterq-dump`.

FastQC was used to assess:

- Per-base sequence quality
- Mean Phred quality scores
- GC content
- Sequence-length distribution
- Adapter contamination

MultiQC was used to combine the individual FastQC reports into one summary report.

All samples showed consistently high sequence quality, with mean Phred scores above 30 across base positions. Adapter contamination was minimal, so read trimming was not required.

### Read Alignment

Paired-end reads were aligned to the **mm10 mouse reference genome** using HISAT2.

SAMtools was then used to:

- Convert SAM files to BAM format
- Sort BAM files
- Index aligned BAM files

All samples achieved alignment rates above approximately 90%, indicating good sequencing quality and compatibility with the selected reference genome.

### Transcript Assembly and Annotation

StringTie was used to perform reference-guided transcript assembly and estimate gene-expression abundance.

The GENCODE vM37 annotation file was used to assign aligned reads to known mouse genes and transcripts.

The main outputs included:

- Transcript-level GTF files
- Gene-abundance tables
- FPKM expression values

### Gene-Expression Analysis

Gene-abundance files were imported into R and filtered for **Mmp2** and **Mmp9**.

Sample metadata were merged with the expression data, and mean FPKM values were calculated for each gene and scaffold treatment.

The following visualizations were created:

- Bar plots of mean expression by treatment
- Dot plots showing replicate-level expression patterns

---

## Results

### Mmp9 Expression

Mmp9 expression varied across the three scaffold treatments:

- **CaP Zn:** approximately 12.6 mean FPKM
- **CaP Zn0.8Mn0.1Li:** approximately 12.4 mean FPKM
- **CaP Zn0.8Mn:** approximately 10.1 mean FPKM

The CaP Zn treatment showed the highest average Mmp9 expression. This may indicate a stronger macrophage inflammatory or tissue-remodeling response.

The replicate-level plots also showed greater variability within the CaP Zn0.8Mn treatment group.

### Mmp2 Expression

Mmp2 expression was not detected in any of the three scaffold-treatment groups.

All samples had FPKM values of zero, suggesting that these scaffold conditions did not induce measurable Mmp2 expression in RAW264.7 macrophages.

---

## Conclusion

This project used RNA-seq analysis to examine how zinc-based calcium phosphate scaffolds influence **Mmp2** and **Mmp9** expression in mouse macrophages.

Mmp9 expression was highest in the CaP Zn treatment group, suggesting that the zinc-based scaffold may promote a stronger tissue-remodeling or inflammatory response. Mmp2 was not detectably expressed under any treatment condition, indicating that it may not play a major role in the macrophage response within this experimental context.

These findings demonstrate how biomaterial composition may influence macrophage activity and provide insight into the molecular mechanisms involved in tissue repair, inflammation, and osseointegration.

---

## Limitations

- Only two biological replicates were available for each scaffold treatment.
- The project used a public dataset, limiting control over experimental conditions.
- Scaffold preparation and exposure time could not be modified.
- The analysis focused only on Mmp2 and Mmp9 rather than genome-wide differential expression.
- Formal statistical testing was not completed because of the small sample size.

---

## Future Directions

Future work could include:

- Performing statistical comparisons across scaffold treatments
- Increasing the number of biological replicates
- Conducting genome-wide differential-expression analysis
- Examining additional inflammatory and tissue-remodeling genes
- Performing pathway and gene-ontology enrichment analysis
- Validating expression results using qPCR
- Investigating whether scaffold treatments influence M1 or M2 macrophage polarization

---

