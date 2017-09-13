#!/bin/bash

EXEC_PATH="../build/supervised-lda/build"

INPUT="../data/LDApp/20newsgroupsCorpus.npy"
OUTPUT="../model/LDApp/20newsgroupsModel.npy"

RUN_LDA="$EXEC_PATH/lda train"

RUN_LDA+=" --topics 20"
RUN_LDA+=" --iterations 20"
RUN_LDA+=" --quiet"
#RUN_LDA+=" --e_step_iterations 100 "
RUN_LDA+=" --e_step_tolerance 0.1"
RUN_LDA+=" --snapshot_every 100"
RUN_LDA+=" --workers 4"
RUN_LDA+=" $INPUT"
RUN_LDA+=" $OUTPUT"


topp() (
  $* &>/dev/null &
  pid="$!"
  trap ':' INT
  echo 'CPU  MEM'
  while sleep 1; do ps --no-headers -o '%cpu,%mem' -p "$pid"; done
  kill "$pid"
)


MEM_CHECK="../build/memusg/memusg"
#valgrind -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out $RUN_LDA ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 ; print foo "MB" }'


$MEM_CHECK $RUN_LDA

#topp $RUN_LDA

echo "Execution time : $SECONDS s."
#ps -C $RUN_LDA -o %cpu,%mem,cmd
#ps -p $RUN_LDA $INPUT $OUTPUT -o %cpu,%mem,cmd

