#! /usr/bin/python

import numpy as np



def load_WT_table(WT_file_name):
    WT_file = open(WT_file_name,'r')
    # get topic nb
    topicNb = 0
    for rawline in WT_file:
        line = rawline.strip('\n')
        #cols = line.strip().split('\t')
        line = line.split('\t')
        cols = line[1].split(' ')
        topicNb = len(cols)

    # go back to beginning of file
    WT_file.seek(0)
    WT_table = np.empty((0,topicNb), np.float64)
    vocab = []
    for rawline in WT_file:
        line = rawline.strip('\n')
        line = line.split('\t')
        vocab.append(line[0])
        cols = line[1].split(' ')
        cols = np.array(cols).astype(np.float)
        WT_table = np.append(WT_table, np.array([cols]), axis=0)
        
    # normalize
    normalization_vector = WT_table.sum(0)
    WT_table = WT_table / normalization_vector[np.newaxis, :]
    return WT_table, vocab



def print_human(wt_table, vocabulary):
    topicNb = len(wt_table[0])
    vocabNb = len(vocabulary)
    human_word_topic_table = {}

    for topicIdx in range(topicNb):
        human_word_topic_table.update({topicIdx:{}})

    #for p, name in zip(wt_table, vocabulary):
    #    print("name = {} values = {}".format(name, p))
    for topicIdx in range(topicNb):
        print(topicIdx)
        for wordIdx in range(vocabNb):
            proba = wt_table[wordIdx][topicIdx]
            wname = vocabulary[wordIdx]
            human_word_topic_table[topicIdx].update({wname:proba})

    outfile = "../model/PLDA/20newsgroupsReadableModelPLDA.txt"
    output_file = open(outfile, 'w')


    probaThreshold = 0.006
    maxWordDistToPrint = 20
    for topIdx in human_word_topic_table:
        print("---------------------")
        output_file.write("---------------------" + '\n')
        topicTitle = "Topic " + str(topIdx)
        print (topicTitle)
        output_file.write(topicTitle + '\n')
        sum = 0
        counter = 0
        for w in sorted(human_word_topic_table[topIdx], key=human_word_topic_table[topIdx].get, reverse=True):
            proba = human_word_topic_table[topIdx][w]
            sum += proba
            if proba > probaThreshold or counter < maxWordDistToPrint:

                tempLine = str(counter+1) + " " + w + "\t " + str(proba)
                print (tempLine)
                output_file.write(tempLine + '\n')
                counter += 1
    output_file.close()


model = "../model/PLDA/20newsgroupsModelPLDA.txt"
#vocab = "../data/PLDA/vocab.pickle"

wt, voc = load_WT_table(model)

print_human(wt, voc)

#for p, name in zip(wt, voc):
#    print("name = {} values = {}".format(name, p))


