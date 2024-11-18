#!/usr/bin/env nextflow
 
nextflow.enable.dsl=2

params.input_cram = ""
params.ref_fasta = ""

workflow {
    cram_ch = Channel.fromPath(params.input_cram)
    cram_ch.view()

    ref_ch = Channel.fromPath(params.ref_fasta)
    ref_ch.view()

    args_ch = cram_ch.combine(ref_ch)
    args_ch.view()

    cramToFastq(args_ch)
}

process cramToFastq {
    container 'htslib-samtools:latest'
    // pod annotation: 'scheduler.illumina.com/presetSize', value: 'standard-small'
    // pod annotation: 'volumes.illumina.com/scratchSize', value: '30GiB'
    publishDir "out" // mode: 'symlink'
 
    input:
    tuple path(input_cram), path(ref_fasta)
 
    output:
    path "${sample_id}_R1.fastq.gz"
    path "${sample_id}_R2.fastq.gz"

    // samtools-fastq options:
    // -n Read names to be left as they are
    // -O Use quality values from OQ tags.
    // -1 FILE Write reads with the READ1 FLAG set to FILE
    // -2 FILE Write reads with the READ2 FLAG set to FILE
    // -i add Illumina Casava 1.8 format entry to header (eg 1:N:0:ATCACG)
    // --threads INT Number of threads to use in addition to main thread [0].
    // --index-format STR string to describe how to parse the barcode and quality tags.
    // --reference Specifies a FASTA reference file for use in CRAM encoding or decoding.
    
    script:

    // Extract sample_id from file name (NA12878.bqsr.cram -> NA12878)
    sample_id = input_cram.getSimpleName()
    println "Processing ${sample_id}..."
    // Convert CRAM to FASTQ
    """
    samtools fastq -n -O -1 ${sample_id}_R1.fastq.gz -2 ${sample_id}_R2.fastq.gz -i --index-format i8 --threads 4 --reference ${ref_fasta} ${input_cram}
    """
}
