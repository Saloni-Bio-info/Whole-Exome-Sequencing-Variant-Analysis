# Whole-Exome Sequencing (WES) Variant Analysis

## Project Overview
This project implements a whole-exome sequencing (WES) analysis workflow using publicly available paired-end sequencing data from the NCBI Sequence Read Archive (SRA).

The workflow covers read quality control, adapter trimming, alignment to the human reference genome, duplicate marking, variant calling, genotyping, and variant-level filtering.

## Dataset Information

| Field | Details |
|---|---|
| SRA Run | SRR9050859 |
| Experiment | SRX5827184 |
| BioProject | PRJNA542230 |
| Sample | X12 |
| Sequencing platform | Illumina HiSeq X Ten |
| Sequencing strategy | Whole-exome sequencing |
| Library selection | Hybrid selection |
| Reference genome | GRCh38.p14 |

## Tools Used

- FastQC
- fastp
- MultiQC
- BWA-MEM
- SAMtools
- GATK 4
- BCFtools

## Workflow

1. **Quality Control:** Initial FASTQ quality assessment using FastQC.
2. **Read Trimming:** Adapter trimming and quality filtering using fastp.
3. **Post-trimming QC:** FastQC and MultiQC reports.
4. **Alignment:** Paired-end read alignment to GRCh38 using BWA-MEM.
5. **BAM Processing:** Sorting, indexing, alignment QC, and duplicate marking.
6. **Variant Calling:** GATK HaplotypeCaller in GVCF mode.
7. **Genotyping:** GATK GenotypeGVCFs to generate a multisample-compatible variant call format (VCF) output.
8. **Variant Filtering:** GATK VariantFiltration using QUAL and DP thresholds.
9. **Statistics:** Variant statistics generated using BCFtools.

## Key Results

| Metric | Result |
|---|---:|
| Primary reads | 123,379,488 |
| Primary mapping rate | 99.99% |
| Properly paired reads | 99.02% |
| Duplicate rate | 27.21% |
| Raw variant records | 545,213 |
| SNPs | 457,292 |
| INDELs | 88,081 |
| PASS variants | 148,875 |
| Mean variant QUAL | 415.38 |
| Mean INFO/DP | 23.91 |
| Ti/Tv ratio | 2.04 |

## Repository Structure

```text
Whole-Exome-Sequencing-Variant-Analysis/
├── scripts/
│   ├── 01_fastq_qc_trimming.sh
│   ├── 02_alignment.sh
│   ├── 03_alignment_qc_markduplicates.sh
│   ├── 04_variant_calling.sh
│   └── 05_variant_filtering.sh
├── qc/
│   ├── fastp.html
│   ├── fastp.json
│   └── multiqc_report.html
├── results/
│   ├── SRR9050859.dup_metrics.txt
│   ├── SRR9050859.flagstat.txt
│   ├── SRR9050859.stats.txt
│   ├── SRR9050859.vcfstats.txt
│   └── validation_summary.txt
└── README.md
```

## Important Limitations

- Base Quality Score Recalibration (BQSR) was not performed because the available known-sites resource had incompatible chromosome naming conventions with the reference genome.
- The exome capture BED file was unavailable; therefore, target-specific coverage analysis was not performed.
- Strict GVCF validation reported an allele/genotype consistency issue. The raw genotyped VCF passed GATK validation.
- Variant filtering used QUAL < 30 and DP < 10 thresholds. These filters flag records rather than remove them.
- Functional annotation and clinical interpretation were not performed.
- These results are for computational learning and research practice, not clinical diagnosis.

## Reproducibility

The shell scripts in `scripts/` document the major analysis steps. Update the input and reference paths according to your system before execution.

Required reference genome: GRCh38.p14.

Large sequencing files and intermediate genomic files (FASTQ, BAM, GVCF, and VCF) are intentionally excluded from this repository.

## Author

Saloni  
MSc Bioinformatics  
GitHub: [Saloni-Bio-info](https://github.com/Saloni-Bio-info)
