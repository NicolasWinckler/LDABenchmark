#!/bin/bash


MEM_CHECK="../build/memusg/memusg"
EXEC_PATH="../build/LightLDA/bin"
IO_PATH="../data/LightLDA"

DOC_NB=11314
VOCAB_NB=1000
ITERATION_NB=100
TOPIC_NB=20
WORKER_NB=4
ALPHA=0.1
BETA=0.01
DATA_CAP=800
MH_STEPS=2

if [[ "$#" -eq 1 ]]; then
key="$1"
case $key in
    -h|--help)
	echo "possible command lines"
	echo "  -n or --iterations arg (default=$ITERATION_NB)"
	echo "  -k or --topics arg (default=$TOPIC_NB)"
	echo "  -w or --workers arg (default=$WORKER_NB)"
	echo "  -a or --alpha arg (default=$ALPHA)"
	echo "  -b or --beta arg (default=$BETA)"
	echo "  -d or --max_num_document arg (default=$DOC_NB)"
	echo "  -l or --num_vocabs arg (default=$VOCAB_NB)"
	echo "  -c or --data_capacity arg (default=$DATA_CAP)"
	echo "  -m or --mh_steps arg (default=$MH_STEPS)"
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
    -a|--alpha)
    ALPHA="$2"
    shift
    ;;
    -b|--beta)
    BETA="$2"
    shift
    ;;
    -d|--max_num_document)
    DOC_NB="$2"
    shift
    ;;
    -l|--num_vocabs)
    VOCAB_NB="$2"
    shift
    ;;
    -c|--data_capacity)
    DATA_CAP="$2"
    shift
    ;;
    -m|--mh_steps)
    MH_STEPS="$2"
    shift
    ;;
    *)
	echo "Unknown command line. Use -h or --help command to list the commands"
	exit
    ;;
esac
shift 
done



LIGHTLDA="$EXEC_PATH/lightlda"

LIGHTLDA+=" -num_vocabs $VOCAB_NB"
LIGHTLDA+=" -num_topics $TOPIC_NB"
LIGHTLDA+=" -num_iterations $ITERATION_NB"
LIGHTLDA+=" -alpha $ALPHA"
LIGHTLDA+=" -beta $BETA"
LIGHTLDA+=" -mh_steps $MH_STEPS"
LIGHTLDA+=" -num_local_workers $WORKER_NB"
LIGHTLDA+=" -num_blocks 1"
LIGHTLDA+=" -max_num_document $DOC_NB"
LIGHTLDA+=" -input_dir $IO_PATH"
LIGHTLDA+=" -data_capacity $DATA_CAP"
#LIGHTLDA+=" -out_of_core"






$MEM_CHECK $LIGHTLDA

echo "Execution time : $SECONDS s."

# cleaning, and moving models to model directory
mv server_0_table_0.model ../model/LightLDA/server_0_table_0.model
mv server_0_table_1.model ../model/LightLDA/server_0_table_1.model
mv doc_topic.0 ../model/LightLDA/doc_topic.0
mv *.log ../model/LightLDA/
