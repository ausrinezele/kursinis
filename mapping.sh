#!/bin/bash

threads=16

# mapping contigs on the reference genomes
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

# mapping trimmed raw reads on the contigs
for i in data/outputs/contigs/*.fasta
do 
    REF=${i}
    bwa index ${i}
    for j in data/outputs/trimmedData/final/*_1.fq.gz
    do
       R1=${j}
       R2="data/outputs/trimmedData/final/"$(basename ${j} _1.fq.gz)"_2.fq.gz"
       BASE="data/outputs/map/rawmap/"$(basename ${i} .fasta)"/"$(basename ${j} .fq.gz)""
       SAM="${BASE}/reads.sam"
       BAM="${BASE}/reads.bam"
       BAM_S="${BASE}/reads_sorted.bam"
       BAM_U="${BASE}/reads_unmapped.bam"
       FASTA_U="${BASE}/reads_unmapped.fasta"
       FLAG="${BASE}/flagstat.txt"

       mkdir -p ${BASE}

       bwa mem -t ${threads} ${REF} ${R1} ${R2} > ${SAM}
       samtools view -bS ${SAM} > ${BAM}
       samtools sort ${BAM} -o ${BAM_S}
       samtools index ${BAM_S}
       samtools view -b -f 4 ${BAM_S} > ${BAM_U}
       samtools fasta ${BAM_U} > ${FASTA_U}
       samtools flagstat ${BAM_S} > ${FLAG}
    done
done

# mapping raw reads (before trimming) on the contigs
for i in data/outputs/contigs/*.fasta
do 
    REF=${i}
    bwa index ${i}
    for j in data/input/*_1.fastq.gz
    do
       R1=${j}
       R2="data/input/"$(basename ${j} _1.fastq.gz)"_2.fastq.gz"
       BASE="data/outputs/map/rawmap_beforeTrim/"$(basename ${i} .fasta)"/"$(basename ${j} .fastq.gz)""
       SAM="${BASE}/reads.sam"
       BAM="${BASE}/reads.bam"
       BAM_S="${BASE}/reads_sorted.bam"
       BAM_U="${BASE}/reads_unmapped.bam"
       FASTA_U="${BASE}/reads_unmapped.fasta"
       FLAG="${BASE}/flagstat.txt"

       mkdir -p ${BASE}

       bwa mem -t ${threads} ${REF} ${R1} ${R2} > ${SAM}
       samtools view -bS ${SAM} > ${BAM}
       samtools sort ${BAM} -o ${BAM_S}
       samtools index ${BAM_S}
       samtools view -b -f 4 ${BAM_S} > ${BAM_U}
       samtools fasta ${BAM_U} > ${FASTA_U}
       samtools flagstat ${BAM_S} > ${FLAG}
    done
done

# RAST notes
# 1434680 -> Sp_2
# 1434681 -> Sp_5
# 1434694 -> NC_003028
# 1434696 -> NC_010380