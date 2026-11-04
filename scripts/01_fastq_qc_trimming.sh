#!/bin/bash
set -euo pipefail

# Input FASTQ files
R1="$HOME/SRA/SRR9050859/SRR9050859_1.fastq.gz"
R2="$HOME/SRA/SRR9050859/SRR9050859_2.fastq.gz"

# Output directory
OUT="$HOME/SRA/SRR9050859"

mkdir -p "$OUT/fastqc" "$OUT/fastqc_clean"

# Initial quality control
fastqc "$R1" "$R2" -o "$OUT/fastqc" -t 4

# Adapter trimming and quality filtering
fastp \
  -i "$R1" \
  -I "$R2" \
  -o "$OUT/clean_R1.fastq.gz" \
  -O "$OUT/clean_R2.fastq.gz" \
  -h "$OUT/fastp.html" \
  -j "$OUT/fastp.json" \
  -w 4

# Post-trimming quality control
fastqc "$OUT/clean_R1.fastq.gz" "$OUT/clean_R2.fastq.gz" \
  -o "$OUT/fastqc_clean" -t 4

# Aggregate post-trimming QC
multiqc "$OUT/fastqc_clean" "$OUT/fastp.json" \
  -o "$OUT/multiqc_clean" -f

echo "FASTQ QC and trimming completed."
