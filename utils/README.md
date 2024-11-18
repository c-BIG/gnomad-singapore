# gnomad-Singapore / Utils

## Conda environment & jupyter notebooks

* From the root folder of the repository (./gnomad-singapore)
* Create conda environment

```sh
conda update -n base -c default conda
conda env create --file ./utils/environment.yml
conda activate gnomad
```

* Start Jupyter

```sh
jupyter lab
```

## Illumina Connected Analytics

* Install ICA CLI following [instructions](https://help.ica.illumina.com/command-line-interface/cli-installation)
* Create an API key following [instructions](https://help.ica.illumina.com/get-started/gs-getstarted#api-keys)

## Environment variables

In order to keep the private information away from the public repository, we define environment variables using dot-env module. We also keep sample metadata and file list in a private directory that is not published on the public repository.

* TEST # default variable to test dot-env module
* DGO_META # sample metadata file (.txt.gz)
* CRAM_LIST # cram file list (.csv)
* CRAM_BUCKET # s3 bucket containing gatk4 cram files
* CRAM_MANIFEST # S3 file manifest of cram files (.csv)
* CRAI_MANIFEST # S3 file manifest of crai files (.csv)
* GVCF_LIST # gvcf file list (.csv)
* ICA_API_KEY # ICA API key (str)
* ICA_PROJECT_ID # ICA project id (str)
* ICA_PREFIX # ICA storage BYOB prefix (s3://bucket/path/)
