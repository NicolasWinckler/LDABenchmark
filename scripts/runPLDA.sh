#!/bin/bash


topp() (
  $* &>/dev/null &
  pid="$!"
  trap ':' INT
  echo 'CPU  MEM'
  while sleep 1; do ps --no-headers -o '%cpu,%mem' -p "$pid"; done
  kill "$pid"
)

MEM_CHECK="../build/memusg/memusg"


EXEC_PATH="../build/plda"
INPUT_PATH="../data/PLDA"
MODEL_PATH="../model/PLDA"


# sequential version

RUN_PLDA="$EXEC_PATH/lda"

# MPI version
PROC_NB="4"
RUN_MPI_LDA="mpiexec"
RUN_MPI_LDA+=" -n $PROC_NB"
RUN_MPI_LDA+=" $EXEC_PATH/mpi_lda"


# Argument
PLDA_CMD_ARGS=""
PLDA_CMD_ARGS+=" --num_topics 20" 
PLDA_CMD_ARGS+=" --alpha 0.1"
PLDA_CMD_ARGS+=" --beta 0.01"
PLDA_CMD_ARGS+=" --training_data_file $INPUT_PATH/20newsgroupsCorpus.txt" 
PLDA_CMD_ARGS+=" --model_file $MODEL_PATH/20newsgroupsModelPLDA.txt"
PLDA_CMD_ARGS+=" --burn_in_iterations 100" 
PLDA_CMD_ARGS+=" --total_iterations 120"


#$MEM_CHECK $RUN_PLDA $PLDA_CMD_ARGS

$MEM_CHECK $RUN_MPI_LDA $PLDA_CMD_ARGS

echo "Execution time : $SECONDS s."

