#!/bin/bash


mkdir -p data
mkdir -p data/LDApp
mkdir -p data/LightLDA
mkdir -p data/paraLDA
mkdir -p model
mkdir -p model/LDApp
mkdir -p model/LightLDA
mkdir -p model/paraLDA

python preprocess20newsgroupsData.py

sed 's/ /\t/' ../data/LightLDA/20newsgroupsCorpus.libsvm
