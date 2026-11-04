#!/bin/bash
set -euo pipefail

REF="$HOME/SRA/reference/GRCh38.fa"
OUT="$HOME/SRA/SRR9050859"

INPUT="$OUT/SRR9050859.raw.vcf.gz"
FILTERED="$OUT/SRR9050859.filtered.vcf.gz"

# Apply variant-level quality filters
gatk VariantFiltration \
  -R "$REF" \
  -V "$INPUT" \
  -O "$FILTERED" \
  --filter-name "LowQual" \
  --filter-expression "QUAL < 30.0" \
  --filter-name "LowDP" \
  --filter-expression "DP < 10"

# Generate variant statistics
bcftools stats "$FILTERED" > "$OUT/SRR9050859.vcfstats.txt"

# Count PASS variants
bcftools view -H -f PASS "$FILTERED" | wc -l

echo "Variant filtering and statistics completed."
