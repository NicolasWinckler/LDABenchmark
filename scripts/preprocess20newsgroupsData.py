#!/usr/bin/env python
import pickle

import numpy as np
from sklearn.datasets import fetch_20newsgroups, dump_svmlight_file
from sklearn.feature_extraction.text import CountVectorizer




def processLightLDA(corpus, vocabulary, outdir):
	mat_shape = corpus.get_shape()
	dim_row = mat_shape[0]
	dim_col = mat_shape[1]

	corpusfileName = outdir + "/LightLDA/20newsgroupsCorpus.libsvm"
	vocabfileName = outdir + "/LightLDA/vocab.word_id.dict"
	#----------------------------------------------
	# dump corpus
	# Notes: need the folowing command on this file for special tab in LightLDA format
	# cat data20newsgroup.libsvm | sed 's/ /\t/'
	dump_svmlight_file(corpus,range(dim_row),corpusfileName)

	#----------------------------------------------
	# dump vocabulary
	projection = corpus.sum(0)
	vocabfile = open(vocabfileName,'w')

	for word in range(dim_col):
		line = '\t'.join([str(word), vocabulary[word], str(projection.item(0,word))]) + '\n'
		vocabfile.write(line)

	vocabfile.close()


def processLDApp(corpus, vocabulary, outdir, sk_container):
	corpusfileName = outdir + "/LDApp/20newsgroupsCorpus.npy"
	vocabfileName = outdir + "/LDApp/vocab.pickle"
	#----------------------------------------------
	# dump corpus
	# Notes: need the folowing command on this file for special tab in LightLDA format
	# cat data20newsgroup.libsvm | sed 's/ /\t/'
	with open(corpusfileName, "wb") as f:
		np.save(f, corpus.toarray().astype(np.int32).T)
		np.save(f, sk_container.target.astype(np.int32))

	#----------------------------------------------
	# dump vocabulary
	pickle.dump(vocabulary, open(vocabfileName, "wb"))




def processParaLDA(corpus, vocabulary, outdir):
	mat_shape = corpus.get_shape()
	dim_col = mat_shape[1]

	# must be with same name
	#corpusfileName = outdir + "/paraLDA/20newsgroupsCorpus.data"
	#vocabfileName = outdir + "/paraLDA/vocab.dict"
	corpusfileName = outdir + "/paraLDA/20newsgroups.data"
	vocabfileName = outdir + "/paraLDA/20newsgroups.dict"
	#----------------------------------------------
	# dump corpus
	np.savetxt(corpusfileName, corpus.todense(), delimiter=",")

	#----------------------------------------------
	# dump vocabulary
	vocabfile = open(vocabfileName,'w')
	for word in range(dim_col):
		line = vocabulary[word] + '\n'
		vocabfile.write(line)
	vocabfile.close()



def processPLDA(corpus, vocabulary, outdir):
	mat_shape = corpus.get_shape()
	dim_row = mat_shape[0]
	dim_col = mat_shape[1]

	corpusfileName = outdir + "/LightLDA/20newsgroupsCorpus.libsvm"
	vocabfileName = outdir + "/LightLDA/vocab.word_id.dict"
	#----------------------------------------------
	# dump corpus
	# Notes: need the folowing command on this file for special tab in LightLDA format
	# cat data20newsgroup.libsvm | sed 's/ /\t/'
	dump_svmlight_file(corpus,range(dim_row),corpusfileName)

	#----------------------------------------------
	# dump vocabulary
	projection = corpus.sum(0)
	vocabfile = open(vocabfileName,'w')

	for word in range(dim_col):
		line = '\t'.join([str(word), vocabulary[word], str(projection.item(0,word))]) + '\n'
		vocabfile.write(line)

	vocabfile.close()



########################################################### todo: proper main
outputdir = "../data"

print("Fetch 20newsgroups corpus")

# Fetch the newsgroups raw data
newsgroups = fetch_20newsgroups(
    subset="train",
    remove=("headers", "footers", "quotes")
)


print("Data preprocessing start")


# Vectorize them with a vocabulary of 1000 words
tf_vectorizer = CountVectorizer(max_df=0.9, min_df=2, max_features=1000,
                                stop_words="english")
newsCorpus = tf_vectorizer.fit_transform(newsgroups.data)
vocab = tf_vectorizer.get_feature_names()

processLightLDA(newsCorpus, vocab, outputdir)
processLDApp(newsCorpus, vocab, outputdir, newsgroups)
processParaLDA(newsCorpus, vocab, outputdir)
