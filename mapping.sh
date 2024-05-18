#!/bin/bash

threads=16

for i in data/input/ref_genome/*.fasta
do 
    REF=${i}
    bwa index ${i}
    for j in data/outputs/contigs/*.fasta
    do
       SAMPLE=${j}
       BASE="data/outputs/map/"$(basename ${j} .fasta)"/"$(basename ${i} .fasta)""
       SAM="${BASE}/reads.sam"
       BAM="${BASE}/reads.bam"
       BAM_S="${BASE}/reads_sorted.bam"
       BAM_U="${BASE}/reads_unmapped.bam"
       FASTA_U="${BASE}/reads_unmapped.fasta"
       FLAG="${BASE}/flagstat.txt"

       mkdir -p ${BASE}

       bwa mem -t ${threads} ${REF} ${SAMPLE} > ${SAM}
       samtools view -bS ${SAM} > ${BAM}
       samtools sort ${BAM} -o ${BAM_S}
       samtools index ${BAM_S}
       samtools view -b -f 4 ${BAM_S} > ${BAM_U}
       samtools fasta ${BAM_U} > ${FASTA_U}
       samtools flagstat ${BAM_S} > ${FLAG}
    done
done
