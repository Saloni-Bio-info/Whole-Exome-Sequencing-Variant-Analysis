#!/bin/bash
set -euo pipefail

REF="$HOME/SRA/reference/GRCh38.fa"
OUT="$HOME/SRA/SRR9050859"

BAM="$OUT/SRR9050859.markdup.bam"
GVCF="$OUT/SRR9050859.g.vcf.gz"
VCF="$OUT/SRR9050859.raw.vcf.gz"

# Generate reference indexes if required
samtools faidx "$REF"

# Generate sequence dictionary if required
if [[ ! -f "${REF%.fa}.dict" ]]; then
    gatk CreateSequenceDictionary \
      -R "$REF" \
      -O "${REF%.fa}.dict"
fi

# Generate genomic VCF
gatk HaplotypeCaller \
  -R "$REF" \
  -I "$BAM" \
  -O "$GVCF" \
  -ERC GVCF \
  --native-pair-hmm-threads 4 \
  --tmp-dir /tmp

# Genotype GVCF
gatk GenotypeGVCFs \
  -R "$REF" \
  -V "$GVCF" \
  -O "$VCF"

# Validate raw VCF
gatk ValidateVariants \
  -R "$REF" \
  -V "$VCF"

echo "Variant calling and genotyping completed."
