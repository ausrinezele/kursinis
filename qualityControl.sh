#!/bin/bash

threads=8

# quality before trimming
for i in ../input/*_1.fastq.gz 
do 
   R1=${i}
   R2="../input/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz"
   fastqc -t ${threads} ${R1} ${R2} -o ../outputs3/quality/before
   R1_fastq="../input/"$(basename ${i} _1.fastq.gz)"_1.fastq"
   R2_fastq="../input/"$(basename ${i} _1.fastq.gz)"_2.fastq"
   jellyfish count -C -m 21 -s 200M -t ${threads} -o ../outputs3/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_kmer_counts.jf ${R1_fastq} ${R2_fatsq}
   jellyfish histo -o ../outputs3/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.txt ../outputs3/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_kmer_counts.jf
   python3 histogram.py ../outputs3/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.txt ../outputs3/quality/k_mer/"$(basename ${i} _1.fastq.gz)"_histrogram.png
done

# trimming data
for i in ../input/*_1.fastq.gz 
do 
    R1=${i}
    R2="../input/"$(basename ${i} _1.fastq.gz)"_2.fastq.gz"
    trim_galore -j ${threads} --length 20 --quality 20 --clip_R1 7 --clip_R2 7 -o ../outputs3/trimmedData --paired ${R1} ${R2}
done

# additional trimming + fastqc
for i in ../outputs3/trimmedData/*_1_val_1.fq.gz 
do 
    R1=${i}
    R2="../outputs3/trimmedData/"$(basename ${i} _1_val_1.fq.gz)"_2_val_2.fq.gz"
    R1B="../outputs3/trimmedData/bbduk/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2B="../outputs3/trimmedData/bbduk/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    R1T="../outputs3/trimmedData/tadpole/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2T="../outputs3/trimmedData/tadpole/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    R1F="../outputs3/trimmedData/final/"$(basename ${i} _1_val_1.fq.gz)"_1.fq.gz"
    R2F="../outputs3/trimmedData/final/"$(basename ${i} _1_val_1.fq.gz)"_2.fq.gz"
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/bbduk.sh in=${R1} in2=${R2} out=${R1B} out2=${R2B} qtrim=r trimq=30 -minlength=18
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/tadpole.sh in=${R1B} in2=${R2B} out=${R1T} out2=${R2T} mode=correct k=15 overwrite=true tossuncorrectable=true prefilter
    /mnt/c/Users/ausri/Downloads/BBMap_39.06/bbmap/bbnorm.sh in=${R1T} in2=${R2T} out=${R1F} out2=${R2F} min=2 threads=${threads}
    fastqc -t ${threads} ${R1F} ${R2F} -o ../outputs3/quality/after
done