#!/bin/bash


EXEC_PATH="../build/plda"
IO_PATH="../data/PLDA"


RUN_PLDA="$EXEC_PATH/lda"

RUN_PLDA+=" -num_vocabs 1000"
RUN_PLDA+=" -num_topics 20"
RUN_PLDA+=" -num_iterations 100"
RUN_PLDA+=" -alpha 0.1"
RUN_PLDA+=" -beta 0.01"
RUN_PLDA+=" -mh_steps 2"
RUN_PLDA+=" -num_local_workers 4"
RUN_PLDA+=" -num_blocks 1"
RUN_PLDA+=" -max_num_document 11314"
RUN_PLDA+=" -input_dir $IO_PATH"
RUN_PLDA+=" -data_capacity 800"
#RUN_PLDA+=" -out_of_core"



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


$MEM_CHECK $RUN_PLDA

#valgrind --tool=massif --pages-as-heap=yes --massif-out-file=massif.out ./PROG ARG1 ... ARGN; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1

#valgrind -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out "$RUN_PLDA" ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 ; print foo "MB" }'
#topp 
#$RUN_PLDA

#valgrind --leak-check=no -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out $RUN_PLDA ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 /1024 ; print foo "GB" }'
#
echo "Execution time : $SECONDS s."

# cleaning, and moving models to model directory
mv server_0_table_0.model ../model/LightLDA/server_0_table_0.model
mv server_0_table_1.model ../model/LightLDA/server_0_table_1.model
mv doc_topic.0 ../model/LightLDA/doc_topic.0
mv *.log ../model/LightLDA/
