#!/bin/bash

EXEC_PATH="../build/supervised-lda/build"

INPUT="../data/LDApp/20newsgroupsCorpus.npy"
OUTPUT="../model/LDApp/20newsgroupsModel.npy"

ITERATION_NB=20
TOPIC_NB=20
WORKER_NB=4
ESTEP_IT=30

if [[ "$#" -eq 1 ]]; then
key="$1"
case $key in
    -h|--help)
	echo "possible command lines"
	echo "  -n or --iterations arg (default=$ITERATION_NB)"
	echo "  -k or --topics arg (default=$TOPIC_NB)"
	echo "  -w or --workers arg (default=$WORKER_NB)"
	echo "  -e or --e_step_iterations arg (default=$ESTEP_IT)"
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
    -e|--e_step_iterations)
    ESTEP_IT="$2"
    shift
    ;;
    -v|--verbose)
    VERBOSE="$2"
    shift
    ;;
    *)
	echo "Unknown command line. Use -h or --help command to list the commands"
	exit
    ;;
esac
shift 
done




RUN_LDA="$EXEC_PATH/lda train"

RUN_LDA+=" --topics $TOPIC_NB"
RUN_LDA+=" --iterations $ITERATION_NB"
RUN_LDA+=" --quiet"
RUN_LDA+=" --e_step_iterations $ESTEP_IT "
RUN_LDA+=" --e_step_tolerance 0.1"
RUN_LDA+=" --snapshot_every 100"
RUN_LDA+=" --workers $WORKER_NB"
RUN_LDA+=" $INPUT"
RUN_LDA+=" $OUTPUT"



$MEM_CHECK $RUN_LDA

echo "Execution time : $SECONDS s."


