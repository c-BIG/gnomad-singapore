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

* Save the docker image as .tar

  ```sh
  docker save htslib-samtools > htslib-samtools.tar
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

## Import the pipeline into ICA

* Create a ICA Flow pipeline
* Copy the content of main.nf
* Update `process / container` variable with the ICA docker ARN
* Define instance size and disk size using `process / pod annotation`
* Define output as `publishDir "out", mode: 'symlink'`
* Edit the XML configuration to interface `input_cram` and `ref_fasta`

  ```xml
  <pipeline code="" version="1.0" xmlns="xsd://www.illumina.com/ica/cp/pipelinedefinition">
    <dataInputs>
      <dataInput code="input_cram" format="CRAM" type="FILE" required="true" multiValue="false">
        <label>input_cram</label>
        <description>CRAM file to be converted in FASTQ</description>
      </dataInput>
      <dataInput code="ref_fasta" format="FASTA" type="FILE" required="true" multiValue="false">
        <label>ref_fasta</label>
        <description>Reference genome fasta file</description>
      </dataInput>
    </dataInputs>
    <steps>
    </steps>
  </pipeline>
  ```

## Run the pipeline within ICA

* In ICA / Flow / Pipeline, Start analysis
* Select the cram and reference fasta
* Start the analysis

## Inspect output

```sh
# zcat < project/cram_to_fastq_output/WHH430-27dc8df6-130a-46dd-be8b-167d43b2e35b/WHH430_R1.fastq.gz | head
@K00115:60:H5LFFBBXX:2:1116:3802:30063 1:N:0:0
TAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTAGGGTTATGGGAAGAGCAAGCGTATGGGCTCGGGTCAGGGCGGGGAATAGGGTATGGGG
+
AAFFFJJJJJJJJJJJJFJJJJJAJFJJJFJJJJJJJJJJJFFJJJJ<AJJJJJJFJJJAJ<FJJ<<JJJJ-FFJJFAFFJJJJ-AFJJFAFJJFJ<F77F--7F-A---7-7<-7<--))-))-7)7))))-))-)----7<---7--)
@K00115:59:H5LJJBBXX:1:1212:19035:24349 1:N:0:0
TAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAAGCCTAACCCTAACCCTAACCCTAACCCTACCCCTAACCCCAACTCCTACCCCAACCCAAACCCTAACCCTAACCCTAACCCTAACCCCAACCC
+
AAFFFJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJFFAFJF<A--F7F<-F--<AJAF-JJ--A-7F--7AAA7AJ-<F----77A--A7--77A-7-----7-7A-----7--7-7<-7---<-<--77F<F7FFAAF-<<-7)
```

FASTQ file looks ok, note that the OQ is restored.
