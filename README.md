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
