#!/bin/bash

threads=16

# quality before trimming
for i in data/input/*_1.fastq.gz 
do 
   R1=${i}
   R2="data/input/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz"
   fastqc -t ${threads} ${R1} ${R2} -o data/outputs/quality/before
   R1_fastq="data/input/"$(basename ${i} _1.fastq.gz)"_1.fastq"
   R2_fastq="data/input/"$(basename ${i} _1.fastq.gz)"_2.fastq"
   jellyfish count -C -m 21 -s 200M -t ${threads} -o data/outputs/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_kmer_counts.jf ${R1_fastq} ${R2_fatsq}
   jellyfish histo -o data/outputs/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.txt data/outputs/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_kmer_counts.jf
   python3 histogram.py data/outputs/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.txt data/outputs/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.png
done

# trimming data
for i in data/input/*_1.fastq.gz 
do 
    R1=${i}
    R2="data/input/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz"
    trim_galore -j ${threads} --length 20 --quality 20 --clip_R1 7 --clip_R2 7 -o data/outputs/trimmedData --paired ${R1} ${R2}
done

# additional trimming + fastqc
for i in data/outputs/trimmedData/*_1_val_1.fq.gz 
do 
    R1=${i}
    R2="data/outputs/trimmedData/"$(basename ${i} _1_val_1.fq.gz)"_2_val_2.fq.gz"
    R1B="data/outputs/trimmedData/bbduk/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2B="data/outputs/trimmedData/bbduk/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    R1T="data/outputs/trimmedData/tadpole/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2T="data/outputs/trimmedData/tadpole/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    R1F="data/outputs/trimmedData/final/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2F="data/outputs/trimmedData/final/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/bbduk.sh in=${R1} in2=${R2} out=${R1B} out2=${R2B} qtrim=r trimq=30 -minlength=18
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/tadpole.sh in=${R1B} in2=${R2B} out=${R1T} out2=${R2T} mode=correct k=15 overwrite=true tossuncorrectable=true prefilter
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/bbnorm.sh in=${R1T} in2=${R2T} out=${R1F} out2=${R2F} min=2 threads=${threads}
    fastqc -t ${threads} ${R1F} ${R2F} -o data/outputs/quality/after
done