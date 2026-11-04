#!/bin/bash
set -euo pipefail

REF="$HOME/SRA/reference/GRCh38.fa"
OUT="$HOME/SRA/SRR9050859"

BAM="$OUT/SRR9050859.sorted.bam"
MARKED_BAM="$OUT/SRR9050859.markdup.bam"

# Alignment statistics before duplicate marking
samtools flagstat "$BAM" > "$OUT/SRR9050859.flagstat_before_markdup.txt"
samtools stats "$BAM" > "$OUT/SRR9050859.stats_before_markdup.txt"

# Mark duplicate reads
gatk MarkDuplicates \
  -I "$BAM" \
  -O "$MARKED_BAM" \
  -M "$OUT/SRR9050859.dup_metrics.txt" \
  --CREATE_INDEX true

# Alignment statistics after duplicate marking
samtools flagstat "$MARKED_BAM" > "$OUT/SRR9050859.flagstat.txt"
samtools stats "$MARKED_BAM" > "$OUT/SRR9050859.stats.txt"

# Check BAM integrity
samtools quickcheck -v "$MARKED_BAM"

echo "Alignment QC and duplicate marking completed."
