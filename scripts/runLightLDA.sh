#!/bin/bash

LIGHTLDA_PATH="/home/nw/quanox/soft/test/LightLDA"
EXEC_PATH="$LIGHTLDA_PATH/bin"
IO_PATH="../data/LightLDA"


LIGHTLDA="$EXEC_PATH/lightlda"

LIGHTLDA+=" -num_vocabs 1100"
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



topp() (
  $* &>/dev/null &
  pid="$!"
  trap ':' INT
  echo 'CPU  MEM'
  while sleep 1; do ps --no-headers -o '%cpu,%mem' -p "$pid"; done
  kill "$pid"
)

#topp 
$LIGHTLDA

echo "Execution time : $SECONDS"
