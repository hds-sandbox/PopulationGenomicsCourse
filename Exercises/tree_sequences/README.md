# Tree sequences

![billede](https://user-images.githubusercontent.com/47324240/158781125-b0d4af85-69dd-4d4a-b722-30da62e8c18f.png)

If the sequences in your data set are individual haplotypes, it is possible to construct the coalescence trees for each nonrecombining segment of a genomic alignment. If you are working on male X chromosomes this is easy because they are haploid and do not require phasing. However, autosomes are diploid, and we would like to use haplotype-based analysis here as well. This can be done through either phasing of short reads mapped to a reference genome, or by assembing each haplotype `de novo` using long reads such as PacBio HiFi. Your chr2 data set is already phased so you are good to go.

In this exercise we will run the Relate program to infer local trees. In the upcomming exercises we will revisit this tree sequence and use it for inference of demography and selection. 

## Request an interactive session on a compute node:

Begin by requesting an interactive job:

```
srun --mem-per-cpu=5g --time=3:00:00 --account=populationgenomics --pty bash
```

## Set up an environment for the exercise:

Relate will produce plots with its population size and marginal tree scripts, and this requires some specific r packages. We install these in a separate environment that we just use for running Relate:

<!-- TODO: Add the below packages to the popgen-notebooks env -->

```
conda create -y -n pg-relate -c conda-forge r-base r-tidyverse r-ggplot2 r-cowplot r-gridextra
```

All the Relate scripts can be run in this environment, so make sure the `pg-relate` is activated when you are working on this exericse. To allow Relate find some files it needs, you also need to run these five commands below *in order*.

```
conda activate pg-relate
conda env config vars set LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/envs/popgen/lib
conda env config vars set PATH=$PATH:$HOME/populationgenomics/software/relate/scripts/EstimatePopulationSize:$HOME/populationgenomics/software/relate/scripts/DetectSelection:$HOME/populationgenomics/software/relate/scripts/DetectSelection/PrepareInputFiles:$HOME/populationgenomics/software/relate/scripts/RelateLSF:$HOME/populationgenomics/software/relate/scripts/DetectSelection/PrepareInputFiles:$HOME/populationgenomics/software/relate/scripts/SampleBranchLengths:$HOME/populationgenomics/software/relate/scripts/DetectSelection/TreeView:$HOME/populationgenomics/software/relate/bin
conda deactivate
conda activate pg-relate
```

## Data

The chr2 data for this exerise is from 60 individuals in the 1000Genomes project. There are 20 individuals from each of the following populations: GBR (British in England and Scotland), JPT (Japanese), YRI (Yoruban).

Create some symlinks that point to the following files:

```
ln -s ~/populationgenomics/data/relate_data/20140520.chr2.strict_mask.fasta
ln -s ~/populationgenomics/data/relate_data/genetic_map_chr2_combined_b37.txt
ln -s ~/populationgenomics/data/relate_data/human_ancestor_2.fa
ln -s ~/populationgenomics/data/relate_data/60_inds.txt
ln -s~/populationgenomics/data/relate_data/chr2_130_145_phased.vcf.gz
```

This way it looks like the files are in your current folder. You can run `ls` to see them. The first file is a mask of genomic regions that either have abnormal read depth or contain repetitive elements. The second file is a recombination map. The third file is the ancestral state of every site, based on an alignment with gorilla, chimpanzee and human genomes. The fourth file is a metadata file detailing the population and region for each sample. The last file is the phased genotype VCF file.

The documentation for Relate can be found [here](https://myersgroup.github.io/relate/).

> **NB:** Running Relate below, you should be away that names of input files are always supplied without the file extensions.

Relate does not accept the standard VCF file format, but instead uses a haps/sample format. You can read up on in the Relate documentation. The authors have been so kind as to supply a script to transform it. First, the vcf is converted to another file format (haplotype file format). If you want to know how it is structured, you can read about it [here](https://www.cog-genomics.org/plink/2.0/formats#haps).

```
RelateFileFormats --mode ConvertFromVcf --haps chr2.haps --sample chr2.sample -i chr2_130_145_phased
```

Then, repetitive (unreliably sequenced) regions must be masked to exclude them form our analysis. We also need to assign each variant as either ancestral or derived using the chimpanzee genome. We do both with this command:

```
PrepareInputFiles.sh --haps chr2.haps --sample chr2.sample --ancestor human_ancestor_2.fa --mask 20140520.chr2.strict_mask.fasta -o prep.chr2
```

Inspect the generated files. 

**Q1: How many SNPs were removed due to non-matching nucleotides?**

**Q2: How many were removed due to the mask?**

## Build trees along the genome

Now, the input is fully prepared, and Relate can be run. This should take less than a minute.

```
Relate --mode All -m 1.25e-8 -N 30000 --haps prep.chr2.haps.gz --sample prep.chr2.sample.gz --map genetic_map_chr2_combined_b37.txt -o chr2_relate
```

**Q3: How many SNPs are left per haplotype?**

## Estimate historical population size and reestimate branch lengths of trees

The lengthiest process is this step, in which population size is estimated, and the population size is re-estimates branch lengths. This takes around 20 minutes. While you are waiting, look at the ARG notebook at the bottom of this page.

```
EstimatePopulationSize.sh -i chr2_relate -m 1.25e-8 --poplabels 60_inds.txt -o popsize --threshold 0
```

> While this is running jump to the bottom part of the exercise about ancestral recombination graphs. One you are done with that part of the exercise, return here to finish the Relate exercise.

----

Relate outputs estimated mutation rate and coalescence times along the region

**Q4: Look at the files and see what you learn**

We will revisit this exercise in later sessions. So for now, just have a look at some of the estimated trees to get an impression of what they look like. You can do this using the command below. You specify the position you want to see using the `--bp_of_interest` option. The command below produces a `tree.pdf` file showing the tree for position 14000000:

```
TreeView.sh --haps chr2.haps --sample chr2.sample --anc popsize.anc --mut popsize.mut --poplabels 60_inds.txt --years_per_gen 28 -o tree --bp_of_interest 14000000
```

**Q5: Try to view some trees close to each other and far from each other. Are close trees the same, why?**

**Q6: Do trees become more different the further away from each other they are, why?**

**Q7: How often do individuals from the same population form a single group? What does that tell you about lineage sorting in humans?**

