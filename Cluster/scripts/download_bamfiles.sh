#!/bin/bash
#SBATCH --mem=1gb
#SBATCH --time=7-00:00:00
#SBATCH --account=populationgenomics

#grep -f ../metadata/samples.txt ../metadata/Simons_meta_ENArun.txt | cut -f 5 | grep -f - ../metadata/ena.ftp.pointers.txt | cut -f 5 | awk '{print "ftp://" $0}' > urls.txt
#wget -nv -i urls.txt

grep -f ../metadata/samples.txt ../metadata/Simons_meta_ENArun.txt | cut -f 5 | grep -f - ../metadata/ena.ftp.pointers.txt | cut -f 4,5 | awk '{print "mkdir -p " $1 " ; wget -nv -P " $1 " ftp://" $2}' | bash
