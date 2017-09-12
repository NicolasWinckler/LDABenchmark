#!/bin/bash

EXEC_PATH="/home/nw/quanox/soft/paraLDA/bin"

#INPUT="../data/paraLDA/20newsgroupsCorpus.data"
#OUTPUT="../data/paraLDA/vocab.dict"


CONFIGFILE="../options/paraLDAConfigFile.txt"
RUN_LDA="$EXEC_PATH/paraLDA $CONFIGFILE"
#cd $EXEC_PATH
#CONFIGFILE:"../../../LDABenchmark/options/paraLDAConfigFile.txt"
#RUN_LDA="paraLDA $CONFIGFILE"

mkdir -p output


topp() (
  $* &>/dev/null &
  pid="$!"
  trap ':' INT
  echo 'CPU  MEM'
  while sleep 1; do ps --no-headers -o '%cpu,%mem' -p "$pid"; done
  kill "$pid"
)

#topp 
$RUN_LDA

#cd -
echo "Execution time : $SECONDS"
#ps -C $RUN_LDA -o %cpu,%mem,cmd
#ps -p $RUN_LDA $INPUT $OUTPUT -o %cpu,%mem,cmd

rmdir output
