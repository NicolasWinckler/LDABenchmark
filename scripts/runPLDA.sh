#!/bin/bash



MEM_CHECK="../build/memusg/memusg"
EXEC_PATH="../build/plda"
INPUT_PATH="../data/PLDA"
MODEL_PATH="../model/PLDA"
VERBOSE=0


ITERATION_NB=110
TOPIC_NB=20
WORKER_NB=4
BURN_IT=100
ALPHA=0.1
BETA=0.01

if [[ "$#" -eq 1 ]]; then
key="$1"
case $key in
    -h|--help)
	echo "possible command lines"
	echo "  -n or --iterations arg (default=$ITERATION_NB)"
	echo "  -k or --topics arg (default=$TOPIC_NB)"
	echo "  -w or --workers arg (default=$WORKER_NB)"
	echo "  -e or --burn_in_iterations arg (default=$BURN_IT must be positive int and smaller than iterations)"
	echo "  -a or --alpha arg (default=$ALPHA)"
	echo "  -b or --beta arg (default=$BETA)"
	echo "  -v or --verbose"
	echo "  -h or --help"
	exit
    ;;
    *)
	echo "Unknown command line. Use -h or --help command"
	exit
    ;;
esac
fi

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -n|--iterations)
    ITERATION_NB="$2"
    shift
    ;;
    -k|--topics)
    TOPIC_NB="$2"
    shift
    ;;
    -w|--workers)
    WORKER_NB="$2"
    shift
    ;;
    -e|--burn_in_iterations)
    BURN_IT="$2"
    shift
    ;;
    -a|--alpha)
    ALPHA="$2"
    shift
    ;;
    -b|--beta)
    BETA="$2"
    shift
    ;;
    -v|--verbose)
    VERBOSE=1
    shift
    ;;
    *)
	echo "Unknown command line. Use -h or --help command to list the commands"
	exit
    ;;
esac
shift 
done


# sequential version
RUN_PLDA="$EXEC_PATH/lda"

# MPI version
RUN_MPI_LDA="mpiexec"
RUN_MPI_LDA+=" -n $WORKER_NB"
RUN_MPI_LDA+=" $EXEC_PATH/mpi_lda"


# Argument
PLDA_CMD_ARGS=""
PLDA_CMD_ARGS+=" --num_topics $TOPIC_NB" 
PLDA_CMD_ARGS+=" --alpha $ALPHA"
PLDA_CMD_ARGS+=" --beta $BETA"
PLDA_CMD_ARGS+=" --training_data_file $INPUT_PATH/docword.nytimes.txt" 
PLDA_CMD_ARGS+=" --model_file $MODEL_PATH/vocab.nytimes.dict"
PLDA_CMD_ARGS+=" --burn_in_iterations $BURN_IT" 
PLDA_CMD_ARGS+=" --total_iterations $ITERATION_NB"


if [[ "$WORKER_NB" -eq 1 ]]; then
$MEM_CHECK $RUN_PLDA $PLDA_CMD_ARGS
else
$MEM_CHECK $RUN_MPI_LDA $PLDA_CMD_ARGS
fi


echo "Execution time : $SECONDS s."

