#! /usr/bin/python

import matplotlib.pyplot as plt

import pickle
import numpy as np

def load_vocab(path):
    _ = np.load(path)
    return np.load(path)

def print_human_readable_word_topic_table(word_topic_table, vocabulary, outputFileName):
    ##########################################################################
    # normalize proba and create a human readable list for each topic with descendent proba


    topicNb = len(word_topic_table)
    vocabNb = len(vocabulary)
    human_word_topic_table = {}

    for topicIdx in range(topicNb):
    	human_word_topic_table.update({topicIdx:{}})


    for topicIdx in range(topicNb):
    	print(topicIdx)
    	for wordIdx in range(vocabNb):
    		proba = word_topic_table[topicIdx][wordIdx]
    		wname = vocabulary[wordIdx]
    		human_word_topic_table[topicIdx].update({wname:proba})

    #output_file = io.open(readable_word_topic_file, 'w', encoding='utf-8')

    outfile = "../model/LDApp/readableModelLDApp.txt"
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






#inputdir = "/home/nicolas/quanox/soft/supervised-lda/mytest/test"
#inputdir = "/home/nw/quanox/soft/supervised-lda/mytest/data20newsgroup"

#model = inputdir + "/news_model.npy_100"
model = "../model/LDApp/20newsgroupsModel.npy"
vocab = "../data/LDApp/vocab.pickle"



with open(model,"rb") as model:
	alpha = np.load(model)
	beta = np.load(model)
	eta = np.load(model)


vocab = load_vocab(vocab)

print_human_readable_word_topic_table(beta, vocab)
