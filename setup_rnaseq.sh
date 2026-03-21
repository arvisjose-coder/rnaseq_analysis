#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo " ÉTAPE 1 : Création de l'environnement"
echo "========================================"
mamba env create -f environment.yml

echo ""
echo "========================================"
echo " ÉTAPE 2 : Kernel Python"
echo "========================================"
mamba run -n rnaseq_env python -m ipykernel install \
    --user \
    --name rnaseq_env \
    --display-name "Python 3 (RNA-seq)"

echo ""
echo "========================================"
echo " ÉTAPE 3 : Kernel R"
echo "========================================"
mamba run -n rnaseq_env Rscript -e \
    "IRkernel::installspec(name='rnaseq_R', displayname='R 4.3 (RNA-seq)', user=TRUE)"

echo ""
echo "========================================"
echo " ÉTAPE 4 : Structure du projet"
echo "========================================"
mkdir -p data/raw
mkdir -p data/reference
mkdir -p data/processed/bam
mkdir -p results/01_fastqc
mkdir -p results/02_alignment
mkdir -p results/03_abundance
mkdir -p results/04_differential_expression
mkdir -p results/05_figures
mkdir -p notebooks
mkdir -p scripts
mkdir -p logs

echo ""
echo "========================================"
echo " ÉTAPE 5 : Git"
echo "========================================"
git init
cat > .gitignore << 'GITEOF'
data/raw/*.fastq.gz
data/raw/*.fastq
data/reference/*.fa
data/reference/*.gtf
data/processed/bam/*.bam
data/processed/bam/*.bai
logs/*.log
.ipynb_checkpoints/
__pycache__/
.Rhistory
.RData
GITEOF

git config --global user.email "arvisjose@gmail.com"
git config --global user.name "DrArvJ.K.D"
git add .
git commit -m "init: pipeline RNA-seq HISAT2 + StringTie + DESeq2"

echo ""
echo "========================================"
echo " TERMINÉ !"
echo "========================================"
echo ""
echo " Kernels disponibles :"
jupyter kernelspec list
echo ""
echo " Structure du projet :"
ls -la
