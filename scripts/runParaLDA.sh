#!/bin/bash

LDAPLUSPLUS="/home/nw/quanox/soft/supervised-lda"

EXEC_PATH="$/home/nw/quanox/soft/paraLDA/bin"

IO_PATH="../data/paraLDA"
INPUT="../data/paraLDA/20newsgroupsCorpus.data"
OUTPUT="../data/paraLDA/vocab.dict"

CONFIGFILE="parameters.txt"
RUN_LDA="$EXEC_PATH/paraLDA $CONFIGFILE"



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

echo "Execution time : $SECONDS"
#ps -C $RUN_LDA -o %cpu,%mem,cmd
#ps -p $RUN_LDA $INPUT $OUTPUT -o %cpu,%mem,cmd

