#!/bin/bash


mkdir -p ../data
mkdir -p ../data/LDApp
mkdir -p ../data/LightLDA
mkdir -p ../data/paraLDA
mkdir -p ../model
mkdir -p ../model/LDApp
mkdir -p ../model/LightLDA
mkdir -p ../model/paraLDA

python preprocess20newsgroupsData.py

sed -i 's/ /\t/' ../data/LightLDA/20newsgroupsCorpus.libsvm
#cat ../data/LightLDA/20newsgroupsCorpus.libsvm | sed 's/ /\t/'


#LIGHTLDA_PATH="/home/nw/quanox/soft/test/LightLDA"
DUMP_BINARY="../build/LightLDA/bin/dump_binary"

INPUT="../data/LightLDA/20newsgroupsCorpus.libsvm"
INPUT+=" ../data/LightLDA/vocab.word_id.dict"

OUTPUT="../data/LightLDA" 
OUTPUT+=" 0"

$DUMP_BINARY $INPUT $OUTPUT


