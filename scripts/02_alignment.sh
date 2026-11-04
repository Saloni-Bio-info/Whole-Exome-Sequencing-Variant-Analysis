#!/bin/bash
set -euo pipefail

REF="$HOME/SRA/reference/GRCh38.fa"
R1="$HOME/SRA/SRR9050859/clean_R1.fastq.gz"
R2="$HOME/SRA/SRR9050859/clean_R2.fastq.gz"
OUT="$HOME/SRA/SRR9050859"

# Align paired-end reads and sort the BAM file
bwa mem -t 4 \
  -R '@RG\tID:SRR9050859\tSM:SRR9050859\tPL:ILLUMINA' \
  "$REF" "$R1" "$R2" |
  samtools sort -@ 4 -o "$OUT/SRR9050859.sorted.bam"

# Index sorted BAM
samtools index "$OUT/SRR9050859.sorted.bam"

# Basic BAM integrity check
samtools quickcheck -v "$OUT/SRR9050859.sorted.bam"

echo "Alignment and sorting completed."
