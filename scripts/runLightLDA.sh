#!/bin/bash

LIGHTLDA_PATH="/home/nw/quanox/soft/test/LightLDA"
EXEC_PATH="$LIGHTLDA_PATH/bin"
IO_PATH="../data/LightLDA"


LIGHTLDA="$EXEC_PATH/lightlda"

LIGHTLDA+=" -num_vocabs 10000"
LIGHTLDA+=" -num_topics 20"
LIGHTLDA+=" -num_iterations 100"
LIGHTLDA+=" -mongo_uri $URI"
LIGHTLDA+=" -alpha 0.1 -beta 0.01 -mh_steps 2"
LIGHTLDA+=" -num_local_workers 4"
LIGHTLDA+=" -num_blocks 1"
LIGHTLDA+=" -max_num_document 11314"
LIGHTLDA+=" -input_dir $IO_PATH"
#LIGHTLDA+=" -output_dir $OUTPUTPATH"
LIGHTLDA+=" -data_capacity 800"
#LIGHTLDA+=" -out_of_core"



topp() (
  $* &>/dev/null &
  pid="$!"
  trap ':' INT
  echo 'CPU  MEM'
  while sleep 1; do ps --no-headers -o '%cpu,%mem' -p "$pid"; done
  kill "$pid"
)


MEM_CHECK="../install/build/memusg/memusg"
#valgrind -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out $RUN_LDA ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 ; print foo "MB" }'


$MEM_CHECK $LIGHTLDA

#valgrind --tool=massif --pages-as-heap=yes --massif-out-file=massif.out ./PROG ARG1 ... ARGN; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1

#valgrind -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out "$LIGHTLDA" ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 ; print foo "MB" }'
#topp 
#$LIGHTLDA

#valgrind --leak-check=no -q --tool=massif --pages-as-heap=yes --massif-out-file=massif.out $LIGHTLDA ; grep mem_heap_B massif.out | sed -e 's/mem_heap_B=\(.*\)/\1/' | sort -g | tail -n 1 | awk '{ foo = $1 / 1024 / 1024 /1024 ; print foo "GB" }'
#
echo "Execution time : $SECONDS"

# cleaning, and moving models to model directory
mv server_0_table_0.model ../model/LightLDA/server_0_table_0.model
mv server_0_table_1.model ../model/LightLDA/server_0_table_1.model
mv doc_topic.0 ../model/LightLDA/doc_topic.0
mv *.log ../model/LightLDA/
