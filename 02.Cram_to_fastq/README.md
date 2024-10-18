# gnomad-Singapore / CRAM to FASTQ

## Create a docker

* Create a Dockerfile and install samtools
* Build the docker image

  ```sh
  docker build --platform linux/amd64 -t htslib-samtools .
  ```

* Run a command within the docker image

  ```sh
  docker run -it htslib-samtools:latest bash
  ```

## Create a Nextflow pipeline

* Local run

  ```sh
  nextflow run main.nf --input_cram NA20412.short.cram --ref_fasta hg38.fa -with-docker htslib-samtools:latest
  ```

* Trace

  ```sh
  N E X T F L O W   ~  version 24.04.4
  Launching `main.nf` [marvelous_hoover] DSL2 - revision: 486da39d6d
  executor >  local (1)
  [40/a8e626] cramToFastq (1) | 1 of 1 ✔
  ```

* Check output

  ```sh
  # zcat < out/NA20412_R1.fastq.gz | head
  @A00217:59:HCFNWDSXX:2:1431:3748:32722 1:N:0:0
  TTATAGAGTAATAATGTCTAGTGTTGGCAGTGCAGAAAGCAAAATGATGAAACTGAAGGGGTAAGCTTGTAATGGCAAGATCAACATGCCTTGCATCATGACTGGAACACAAAGACCTTGGTTGCTGAAACAGCTCTAAGGACTTGGGGT
  +
  ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
  ```
  
  Note that in the example above, the source CRAM do not have OQ

## Check DRAGEN fastq

In the DRAGEN demo, 1 sample has FASTQ files from 4 lanes & separate R1 / R2

the fastq list csv file, use as an input from the DRAGEN run is as below:

```sh
RGID          RGSM    RGLB            Lane  Read1File                         Read2File
NA12878-LANE1 NA12878 UnknownLibrary  L001  NA12878_S24_L001_R1_001.fastq.gz  NA12878_S24_L001_R2_001.fastq.gz
NA12878-LANE2 NA12878 UnknownLibrary  L002  NA12878_S24_L002_R1_001.fastq.gz  NA12878_S24_L002_R2_001.fastq.gz
NA12878-LANE3 NA12878 UnknownLibrary  L003  NA12878_S24_L003_R1_001.fastq.gz  NA12878_S24_L003_R2_001.fastq.gz
NA12878-LANE4 NA12878 UnknownLibrary  L004  NA12878_S24_L004_R1_001.fastq.gz  NA12878_S24_L004_R2_001.fastq.gz
```

Head of the fastq files looks like below:

```sh
# zcat < NA12878_S24_L001_R1_001.fastq.gz | head 
@A00586:118:HYC3FDSXY:1:1101:18936:1000 1:N:0:CAGTGGCACT+CCTATTGTTA
CNTCCAGGTAGTGCCGAAAGAGTGTTTCAAACCTACTCTATAAAAGGGAATATTCAACTCTGTGACTTGAATGCAAACATCACAAAGCAGTTTCTGAGAATGCTTCCGTCTAGATTTTCTATGAAGATATTCCCGTTTCCAACGAAATCTT
+
F#FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFF:FFFFFFFFFFFFFFF:FFFFFFFFF:FFF:
```

```sh
# zcat < NA12878_S24_L001_R2_001.fastq.gz | head
@A00586:118:HYC3FDSXY:1:1101:18936:1000 2:N:0:CAGTGGCACT+CCTATTGTTA
GTACTCAAGTAACAGTGTTGAACCTTCCTTTTGACAGAGTAGTTTTGAAACACTCTTTGGGTAGAATCTGCAAGTGGATATTTGGATAGCTTTGAGGATTTCGTTGGAAACGGGTTATCTTCCTATAAAATCCAGACAGGAGCATTCTCAG
+
FFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFF:FF,FF,F:,FFFFF:FFF,:F:,:,FFFFF:FFFF,FFFFFFFFFFFF,FFF:FFF:::FFFF,FFFFFFF:FF:F,F:F,FF,FFFFF,FFF:F
```
