#!/usr/bin/env python
import pickle
import optparse
import numpy as np
from sklearn.datasets import fetch_20newsgroups, dump_svmlight_file
from sklearn.feature_extraction.text import CountVectorizer
from scipy.sparse import csr_matrix, find



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

	corpusfileName = outdir + "/PLDA/20newsgroupsCorpus.txt"
	vocabfileName = outdir + "/PLDA/vocab.dict"
	#----------------------------------------------
	# dump corpus

	#rows, cols, values = find(corpus)
	#for i, j, v in zip(rows, cols, values):

	pldaCorpusFile = open(corpusfileName, 'w')
	for docId in range(dim_row):
		doc = corpus.getrow(docId)
		_, wordIds, wordCounts = find(doc)
		line = ""
		for wordId, wordCount in zip(wordIds, wordCounts):
			line += str(vocabulary[wordId]) + " " + str(wordCount) + " "
		line +="\n"
		pldaCorpusFile.write(line)
	pldaCorpusFile.close()

	#----------------------------------------------
	# dump vocabulary
	projection = corpus.sum(0)
	vocabfile = open(vocabfileName,'w')

	
	for word in range(dim_col):
		line = '\t'.join([str(word), vocabulary[word], str(projection.item(0,word))]) + '\n'
		vocabfile.write(line)

	vocabfile.close()



########################################################### todo: proper main




def main():
    
    parser = optparse.OptionParser()
    parser.add_option("--data_dir",     dest="outputdir",    type=str,   help="data root directory",   default="../data")
    parser.add_option("--max_df",       dest="max_df",       type=float, help="max_df float in [0,1]", default=0.9)
    parser.add_option("--min_df",       dest="min_df",       type=int,   help="min_df int in [1,N]",   default=2)
    parser.add_option("--max_features", dest="max_features", type=int,   help="Maximum vocab size",    default=1000)


    (options, args) = parser.parse_args()
    outputdir = options.outputdir

    print("Fetch 20newsgroups corpus")
    # Fetch the newsgroups raw data
    newsgroups = fetch_20newsgroups(
        subset="train",
        remove=("headers", "footers", "quotes")
    )


    print("Data preprocessing start")

    
    tf_vectorizer = CountVectorizer(max_df=options.max_df, 
                                    min_df=options.min_df, 
                                    max_features=options.max_features,
                                    stop_words="english")
    newsCorpus = tf_vectorizer.fit_transform(newsgroups.data)
    vocab = tf_vectorizer.get_feature_names()


    shape = newsCorpus.get_shape()
    dim_row = shape[0]
    dim_col = shape[1]
    max_size = dim_row*dim_col
    non_zero_ele = newsCorpus.count_nonzero()
    MBsize = non_zero_ele * 8/1024/1024

    print("Matrix dimensions: D x W = {} x {} = {}".format(dim_row, dim_col, max_size))
    print("Non zero elements: {} (sparse storage)".format(non_zero_ele))
    print("Size estimation: {} MB".format(MBsize))

    processLightLDA(newsCorpus, vocab, outputdir)
    processLDApp(newsCorpus, vocab, outputdir, newsgroups)
    processParaLDA(newsCorpus, vocab, outputdir)
    processPLDA(newsCorpus, vocab, outputdir)

    

if __name__ == "__main__":
    main()


