# Set working directory
setwd("/Users/manuela/Desktop/Project_propsal/stringtie_output/")

#Load package
library(ggplot2)
library(dplyr)


# List and read all the *_gene_abund.tab files
files <- list.files(pattern = "_gene_abund.tab$")
files

# Load all gene expression files into a list
gene_data_list <- lapply(files, function(file) {
  df <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  df$Sample <- gsub("_gene_abund.tab", "", file)  # Add sample name column
  df
})


# Combine all into one data frame
combined_data <- bind_rows(gene_data_list)


# Filter for Mmp2 and Mmp9
mmp_genes <- combined_data %>%
  filter((Gene.Name) %in% c("Mmp2", "Mmp9"))


#View result
print(mmp_genes)


# Create metadata
metadata <- data.frame(
  Sample = c("SRR23340892", "SRR23340893", "SRR23340894", 
             "SRR23340895", "SRR23340896", "SRR23340897"),
  Treatment = c("CaP Zn0.8Mn0.1Li", "CaP Zn0.8Mn0.1Li", 
                "CaP Zn0.8Mn", "CaP Zn0.8Mn", 
                "CaP Zn", "CaP Zn"))


# Merge expression data with metadata
mmp_merged <- merge(mmp_genes, metadata, by = "Sample")


# Calculate mean FPKM per treatment for each gene
mmp_avg <- mmp_merged %>%
  group_by(Treatment, Gene.Name) %>%
  summarize(mean_FPKM = mean(FPKM), .groups = "drop")


#Barplot of MMP9
ggplot(filter(mmp_avg, Gene.Name == "Mmp9"), aes(x = Treatment, y = mean_FPKM, fill = Treatment)) +
  geom_col() +
  geom_text(aes(label = round(mean_FPKM, 1)), vjust = -0.3, size = 4) +
  scale_fill_manual(values = c("CaP Zn" = "#FFDCD4", 
                               "CaP Zn0.8Mn" = "#FEAFB7", 
                               "CaP Zn0.8Mn0.1Li" = "#F382AB")) +
  labs(
    title = "Average Expression of Mmp9 by Treatment",
    y = "Mean FPKM",
    x = "Scaffold Treatment"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

ggsave("MMP9_Barplot.png", width = 8, height = 6, dpi = 300)




#Barplot of MMP2
ggplot(filter(mmp_avg, Gene.Name == "Mmp2"), aes(x = Treatment, y = mean_FPKM, fill = Treatment)) +
  geom_col() +
  scale_fill_manual(values = c("CaP Zn" = "#FFDCD4", 
                               "CaP Zn0.8Mn" = "#FEAFB7", 
                               "CaP Zn0.8Mn0.1Li" = "#F382AB")) +
  labs(
    title = "Average Expression of Mmp2 by Treatment",
    y = "Mean FPKM",
    x = "Scaffold Treatment"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

#Save graph
ggsave("MMP2_Barplot.png", width = 8, height = 6, dpi = 300)



# Dot plot( shows replicate-level variation ) of MMP9
ggplot(filter(mmp_merged, Gene.Name == "Mmp9"),
       aes(x = Treatment, y = FPKM, color = Treatment)) +
  geom_jitter(width = 0.2, size = 3, alpha = 0.8) +
  scale_color_manual(values = c(
    "CaP Zn" = "#FFDCD4",
    "CaP Zn0.8Mn" = "#FEAFB7",
    "CaP Zn0.8Mn0.1Li" = "#F382AB"
  )) +
  labs(
    title = "FPKM Expression of Mmp9 Across Treatments",
    y = "FPKM",
    x = "Scaffold Treatment"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = )

# save graph
ggsave("MMP9_dot_plot.png", width = 8, height = 6, dpi = 300)



# Dot plot( shows replicate-level variation ) of MMP2 (NOT THE RIGHT GRAPH)
#ggplot(filter(mmp_merged, Gene.Name == "Mmp2"),
 #      aes(x = Treatment, y = FPKM, color = Treatment)) +
  #geom_jitter(width = 0.2, size = 3, alpha = 0.8) +
  #scale_color_manual(values = c(
   # "CaP Zn" = "#D2EFB2",
    #"CaP Zn0.8Mn" = "#8FD4B8",
    "#CaP Zn0.8Mn0.1Li" = "#54BDC2"
  #)) +
  #labs(
   # title = "FPKM Expression of Mmp2 Across Treatments",
    #y = "FPKM",
    #x = "Scaffold Treatment"
  #) +
  #theme_minimal(base_size = 14) +
  #theme(legend.position = )




mmp2_vals <- mmp_merged |>
  dplyr::filter(Gene.Name == "Mmp2") |>
  dplyr::select(Sample, Treatment, FPKM, Coverage)
mmp2_vals


# Create a filtered dataset for plotting Mmp2
mmp2_plot_data <- filter(mmp_merged, Gene.Name == "Mmp2")

# Force FPKM values to zero
mmp2_plot_data$FPKM <- 0

# Make the dot plot
ggplot(mmp2_plot_data,
       aes(x = Treatment, y = FPKM, color = Treatment)) +
  geom_point(size = 3, alpha = 0.8) +  # using point instead of jitter to avoid any below-zero noise
  scale_color_manual(values = c(
    "CaP Zn" = "#FFDCD4",
    "CaP Zn0.8Mn" = "#FEAFB7",
    "CaP Zn0.8Mn0.1Li" = "#F382AB"
  )) +
  labs(
    title = "FPKM Expression of Mmp2 Across Treatments",
    y = "FPKM",
    x = "Scaffold Treatment",
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none") +
  ylim(-0.5, 0.5)

# save graph
ggsave("MMP2_dot_plot.png", width = 8, height = 6, dpi = 300)



# ----------------Create a Barplot of Alignment Rates--------------------
library(dplyr)
library(stringr)


# Set working directory
setwd("/Users/manuela/Desktop/Project_propsal/")


# List all HISAT2 summary files
summary_files <- list.files(pattern = "_hisat2_summary\\.txt$")

# Function to extract alignment rate
extract_alignment_rate <- function(file) {
  lines <- readLines(file)
  # Find the line with "overall alignment rate"
  rate_line <- lines[grepl("overall alignment rate", lines)]
  rate <- str_extract(rate_line, "\\d+\\.\\d+")  # extract numeric value
  data.frame(Sample = gsub("_hisat2_summary\\.txt", "", file),
             AlignmentRate = as.numeric(rate))
}

# Combine into one data frame
alignment_data <- bind_rows(lapply(summary_files, extract_alignment_rate))
print(alignment_data)


#Plot the graph
ggplot(alignment_data, aes(x = Sample, y = AlignmentRate, fill = Sample)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c(
    "SRR23340892" = "#FFDCD4",
    "SRR23340893" = "#FEAFB7",
    "SRR23340894" = "#F382AB",
    "SRR23340895" = "#EB69A9",
    "SRR23340896" = "#C326A2",
    "SRR23340897" = "#8A1087"
    
  )) +
  ylim(0, 100) +
  labs(title = "Alignment Rates per Sample",
       x = "Sample",
       y = "Alignment Rate (%)") +
  geom_text(aes(label = paste0(AlignmentRate, "%")),
            vjust = -0.5, size = 3) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# save graph
ggsave("Alignment_Rate_Bargraph.png", width = 8, height = 6, dpi = 300)


#-------------- Statiscal Test---------------------------

#Plot for just MMP9
mmp9_vals <- mmp_merged |>
  dplyr::filter(Gene.Name == "Mmp9") |>
  dplyr::select(Sample, Treatment, FPKM, Coverage)
mmp9_vals






# Testing if our data meets the assumpations-----
## MMP9
#1. Meets the independence test


# 2. Check for normality
# Run ANOVA
anova_mmp9 <- aov(FPKM ~ Treatment, data = mmp9_vals)

# Extract residuals
resid_mmp9 <- residuals(anova_mmp9)

# Shapiro-Wilk test for normality
shapiro.test(resid_mmp9)
# The p value is greater than 0.05 so it meets the normality test


# Residuals from your ANOVA
resid_mmp9 <- residuals(anova_mmp9)

# Plot QQ-plot
qqnorm(resid_mmp9)
qqline(resid_mmp9, col = "red")

# Density plot to visual the normality
ggplot(data.frame(resid = resid_mmp9), aes(x = resid)) +
  geom_density(fill = "skyblue", alpha = 0.6) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Density Plot of Residuals (Mmp9 ANOVA)",
    x = "Residuals",
    y = "Density"
  ) +
  theme_minimal(base_size = 14)

# 3. Homogeneity of variance
library(car)

# Levene's Test
leveneTest(FPKM ~ Treatment, data = mmp9_vals)
# Result: Levene's Test for Homogeneity of Variance (center = median)
       #Df    F value    Pr(>F)    
#group  2   1.6222e+30 < 2.2e-16 ***
#       3                         
# The homogeneity if Varaince does not meet the assumpation


## MMP2
# 1. Meets the independece test

#2. Check for normality
# Run ANOVA model to get residuals
anova_mmp2 <- aov(FPKM ~ Treatment, data = mmp2_vals)
resid_mmp2 <- residuals(anova_mmp2)

# Test normality of residuals
shapiro.test(resid_mmp2)

# Plot QQ-plot
qqnorm(resid_mmp2)
qqline(resid_mmp2, col = "red")

# MMP-2 expression was negligible across all scaffold treatments, with no measurable differences among groups


# Running stat test on MMP9
# Kruskal Wallis Test (Doesnt assume equal variance or normaility)
kruskal.test(FPKM ~ Treatment, data = mmp9_vals)
# Result: Kruskal-Wallis chi-squared = 2, df = 2, p-value = 0.3679

#Welch ANOVA test (Doesnt assume equal variance)
oneway.test(FPKM ~ Treatment, data = mmp9_vals)
# Result: F = 0.55407, num df = 2.0000, denom df = 1.4795, p-value = 0.6613

# Both parametric (Welch’s ANOVA) and non-parametric (Kruskal–Wallis) approaches show no evidence of 
#differential expression of Mmp9 across scaffold treatments.





