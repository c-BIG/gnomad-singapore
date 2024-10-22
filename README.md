# gnomad-singapore

The gnomAD project has demonstrated the value of allele frequency reference datasets that are processed consistently, jointly called, and harmonized. However, this centralized approach is not feasible for all datasets, as some data, particularly from historically marginalized groups, are restricted to specific environments for ethical and legal reasons. In order to incorporate these datasets into gnomAD, we have launched the Federated gnomAD network. This network includes sites from across the globe, including sites in South Africa (H3Africa), Australia (Centre for Population Genomics), Qatar (Qatar Biobank), Singapore (Singapore National Precision Medicine), and Spain (European Genome Phenome Archive). All sites participating in the federated gnomAD plan to process and quality control their data according to gnomAD best practices and freely share aggregate allele frequency data with the primary gnomAD database. As such, each site will produce high quality callsets of their data, and all of the summary data will be aggregated with primary gnomAD data for ease of use by the wider scientific and clinical community.

gnomAD-Singapore is the node managing the Singapore National Precision Medicine.

## Dataset

The dataset to be shared in the context of the federated gnomAD network is Singapore NPM Phase I: SG10K_Health.
SG10K_Health is composed of 10,323 individuals consolidated from 6 pre-existing research cohorts

- GUSTO: 1,000 samples
- HELIOS: 2,400 samples
- MEC: 3,082 samples
- PRISM: 1,350 samples
- SEED: 1,534 samples
- TTSH: 957 samples

SG10K_Health have been initially processed through GATK4 pipeline. Subsequenlty, SG10K_Health have been re-analysed using DRAGEN pipeline.

## Processing

### 01.Sample_manifest

Initially 10,714 samples were registered for the project Singapore National Precision Medicine Phase I.
 A subset of 10,323 samples has been successfully sequenced and processed through GATK4 pipeline to be included in SG10K_Health dataset.
 Subsequenlty, SG10K_Health have been re-analysed using DRAGEN pipeline.

 [2024-10-16] As of today 1,543 samples are missing from the DRAGEN re-analysis

 In order to generate the missing DRAGEN gVCF we start from the GATK4 CRAM, re-create FASTQ files, and run DRAGEN from the FASTQ files.
 First step is to create a file manifest of CRAM & CRAI to restore the files from archive.
 We then restore the file using AWS S3 batch operation and the manifest files.

### 02.Cram_to_fastq

Once the GATK4 CRAM files are restored, we use a nextflow pipeline to convert the CRAM to FASTQ.
 For convenience, we are using Illumina Connected Analytics (ICA) as a platform to process CRAM to FASTQ then run the DRAGEN pipeline.

#### Data preparation

- Create a dedicated project in ICA
- Copy the GATK4 CRAM files in ICA
- Create sample object & link the CRAM files

#### Pipeline development

- Create a Docker image with samtools
- Create a Nextflow pipeline that run `samtools fastq` command
- Test the pipeline on local machine
- Convert the pipeline into a ICA Flow pipeline

#### Cram to Fastq run

- Run ICA Flow analysis to convert the GATK4 CRAM into FASTQ
