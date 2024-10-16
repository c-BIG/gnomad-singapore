# gnomad-Singapore / CRAM to FASTQ

## Create a docker

* Create a Dockerfile and install samtools
* Build the docker image

  ```sh
  docker build --platform linux/amd64 -t htslib-samtools .
  ```
