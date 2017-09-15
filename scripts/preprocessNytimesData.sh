#!/bin/bash




ROOT_DIR=$PWD


mkdir -p ../dump
mkdir -p ../data
mkdir -p ../data/dump
mkdir -p ../data/LDApp
mkdir -p ../data/LightLDA
mkdir -p ../data/paraLDA
mkdir -p ../data/PLDA
mkdir -p ../model
mkdir -p ../model/LDApp
mkdir -p ../model/LightLDA
mkdir -p ../model/paraLDA
mkdir -p ../model/PLDA

cd ../dump

DUMP_DIR=$PWD

#wget https://archive.ics.uci.edu/ml/machine-learning-databases/bag-of-words/docword.nytimes.txt.gz
#gunzip docword.nytimes.txt.gz
#wget https://archive.ics.uci.edu/ml/machine-learning-databases/bag-of-words/vocab.nytimes.txt

cd $ROOT_DIR


python preprocessNytimesData.py

#exit

echo "copy LightLDA files"
#cp $DUMP_DIR/docword.nytimes.libsvm ../data/LightLDA/docword.nytimes.libsvm
#cp $DUMP_DIR/vocab.nytimes.dict ../data/LightLDA/vocab.nytimes.dict

sed -i 's/ /\t/' ../data/LightLDA/docword.nytimes.libsvm


echo "Create binary data format for LightLDA"
#LIGHTLDA_PATH="/home/nw/quanox/soft/test/LightLDA"
DUMP_BINARY="../build/LightLDA/bin/dump_binary"

INPUT="../data/LightLDA/docword.nytimes.libsvm"
INPUT+=" ../data/LightLDA/vocab.nytimes.dict"

OUTPUT="../data/LightLDA" 
OUTPUT+=" 0"

$DUMP_BINARY $INPUT $OUTPUT

