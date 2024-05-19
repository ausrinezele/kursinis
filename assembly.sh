#!/bin/bash

threads=16

# assembly with Spades
for i in data/outputs/trimmedData/final/*_1.fq.gz 
do 
    R1=${i}
    R2="data/outputs/trimmedData/final/"$(basename ${i} _1.fq.gz)"_2.fq.gz"
    OUT="data/outputs/assembly_spades/"$(basename ${i} _1.fq.gz)"_spades"
    spades.py -1 ${R1} -2 ${R2} -o ${OUT}
    cp ${OUT}/contigs.fasta data/outputs/contigs/"$(basename ${i} _1.fq.gz)".fasta
done

# contigs reorder
ragtag.py scaffold data/input/ref_genome/NC_010380.fasta data/outputs/contigs/Sp_2_EKDN240022001-1A_22772HLT4_L8.fasta -o data/outputs/ragtag/Sp_2
ragtag.py scaffold data/input/ref_genome/NC_010380.fasta data/outputs/contigs/Sp_5_EKDN240022002-1A_22772HLT4_L7.fasta -o data/outputs/ragtag/Sp_5

# busco analyse, searching for predicted genes
conda activate busco_env
busco -i data/outputs/contigs/Sp_2_EKDN240022001-1A_22772HLT4_L8.fasta -m genome --auto-lineage -f -o data/outputs/busco/Sp_2
busco -i data/outputs/contigs/Sp_5_EKDN240022002-1A_22772HLT4_L7.fasta -m genome --auto-lineage -f -o data/outputs/busco/Sp_5
conda deactivate
