#!/usr/bin/env python
import pickle
import optparse
import numpy as np
from sklearn.datasets import fetch_20newsgroups, dump_svmlight_file
from sklearn.feature_extraction.text import CountVectorizer
from scipy.sparse import csr_matrix, find
from sklearn.datasets import load_svmlight_file


def processLightLDA(corpus, vocabulary, outdir):
    mat_shape = corpus.get_shape()
    dim_row = mat_shape[0]
    dim_col = mat_shape[1]

    corpusfileName = outdir + "/LightLDA/docword.nytimes.libsvm"
    vocabfileName = outdir + "/LightLDA/vocab.nytimes.dict"
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


def processLDApp(corpus, vocabulary, outdir):
    corpusfileName = outdir + "/LDApp/docword.nytimes.npy"
    vocabfileName = outdir + "/LDApp/vocab.nytimes.pickle"
    #----------------------------------------------
    # dump corpus
    # Notes: need the folowing command on this file for special tab in LightLDA format
    # cat data20newsgroup.libsvm | sed 's/ /\t/'
    with open(corpusfileName, "wb") as f:
        np.save(f, corpus.toarray().astype(np.int32).T)
        #np.save(f, sk_container.target.astype(np.int32))

    #----------------------------------------------
    # dump vocabulary
    pickle.dump(vocabulary, open(vocabfileName, "wb"))




def processParaLDA(corpus, vocabulary, outdir):
    mat_shape = corpus.get_shape()
    dim_col = mat_shape[1]


    # must be with same name
    #corpusfileName = outdir + "/paraLDA/docword.nytimes.data"
    #vocabfileName = outdir + "/paraLDA/vocab.nytimes.dict"
    corpusfileName = outdir + "/paraLDA/docword.nytimes.data"
    vocabfileName = outdir + "/paraLDA/docword.nytimes.dict"
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

    corpusfileName = outdir + "/PLDA/docword.nytimes.txt"
    vocabfileName = outdir + "/PLDA/vocab.nytimes.dict"
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

def uci_to_libsvm(vocab_file_name, data_file_name, libsvm_file_name, dict_file_name):
    data_file = open(data_file_name, 'r')
    vocab_file = open(vocab_file_name, 'r')
    libsvm_file = open(libsvm_file_name, 'w')
    dict_file = open(dict_file_name, 'w')
    word_dict = {}
    vocab_dict = []
    doc = ""
    last_doc_id = 0
    line = vocab_file.readline()
    while line:
        vocab_dict.append(line.strip())
        line = vocab_file.readline()
    vocab_file.close()

    line = data_file.readline()
    while line:
        col = line.strip().split(' ')
        if len(col) == 3:
            doc_id = int(col[0])
            word_id = int(col[1]) - 1
            word_count = int(col[2])
            #if not word_dict.has_key(word_id):
            if word_id not in word_dict:
                word_dict[word_id] = 0
            word_dict[word_id] += word_count
            if doc_id != last_doc_id:
                if doc != "":
                    libsvm_file.write(doc.strip() + '\n')
                doc = str(doc_id) + '\t'
            doc += str(word_id) + ':' + str(word_count) + ' '
            last_doc_id = doc_id
        line = data_file.readline()
    data_file.close()

    if doc != "":
        libsvm_file.write(doc.strip() + '\n')

    libsvm_file.close()
    for wordId in range(len(vocab_dict)):
        if wordId not in word_dict:
            line = ' '.join([str(wordId), vocab_dict[wordId], str(0)]) + '\n'
        else:
            line = ' '.join([str(wordId), vocab_dict[wordId], str(word_dict[wordId])]) + '\n'
        dict_file.write(line)
    dict_file.close()
    return vocab_dict
    

def uci_to_raw_corpus(vocab_file_name, data_file_name):
    data_file = open(data_file_name, 'r')
    vocab_file = open(vocab_file_name, 'r')
    #libsvm_file = open(libsvm_file_name, 'w')
    #dict_file = open(dict_file_name, 'w')
    raw_corpus = []
    word_dict = {}
    vocab_dict = []
    doc = ""
    last_doc_id = 0
    line = vocab_file.readline()
    while line:
        vocab_dict.append(line.strip())
        line = vocab_file.readline()
    vocab_file.close()

    line = data_file.readline()
    while line:
        col = line.strip().split(' ')
        if len(col) == 3:
            doc_id = int(col[0])
            word_id = int(col[1]) - 1
            word_count = int(col[2])
            #if not word_dict.has_key(word_id):
            if word_id not in word_dict:
                word_dict[word_id] = 0
            word_dict[word_id] += word_count
            if doc_id != last_doc_id:
                if doc != "":
                    #libsvm_file.write(doc.strip() + '\n')
                    raw_corpus.append(doc.strip() + '\n')
                #doc = str(doc_id) + '\t'
                doc=""
            doc += str(vocab_dict[word_id]) + ' ' #+ str(word_count) + ' '
            last_doc_id = doc_id
        line = data_file.readline()
    data_file.close()

    if doc != "":
        #libsvm_file.write(doc.strip() + '\n')
        raw_corpus.append(doc.strip() + '\n')


    return vocab_dict, raw_corpus


def main():
    
    parser = optparse.OptionParser()
    parser.add_option("--data_out_dir",    dest="outputdir",    type=str,   help="data root directory",   default="../data")
    parser.add_option("--data_source_dir", dest="sourcedir",    type=str,   help="source dump root directory",   default="../dump")
    parser.add_option("--max_df",          dest="max_df",       type=float, help="max_df float in [0,1]", default=0.9)
    parser.add_option("--min_df",          dest="min_df",       type=int,   help="min_df int in [1,N]",   default=2)
    parser.add_option("--max_features",    dest="max_features", type=int,   help="Maximum vocab size",    default=1000)


    (options, args) = parser.parse_args()
    outputdir = options.outputdir
    sourcedir = options.sourcedir

    vocab_file_name = sourcedir + "/vocab.nytimes.txt"
    data_file_name = sourcedir + "/docword.nytimes.txt"
    #libsvm_file_name = sourcedir + "/docword.nytimes.libsvm"
    #dict_file_name = sourcedir + "/vocab.nytimes.dict"

    #vocab = uci_to_libsvm(vocab_file_name, data_file_name, libsvm_file_name, dict_file_name)
    #newsCorpus, _ = load_svmlight_file(libsvm_file_name)

    print("Get raw corpus")
    rawvocab, rawCorpus = uci_to_raw_corpus(vocab_file_name, data_file_name)



    # stop words used:
    #https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/feature_extraction/stop_words.py
    print("count vectorizer")
    tf_vectorizer = CountVectorizer(#max_df=options.max_df, 
                                    #min_df=options.min_df, 
                                    #max_features=options.max_features,
                                    stop_words="english")
    newsCorpus = tf_vectorizer.fit_transform(rawCorpus)
    vocab = tf_vectorizer.get_feature_names()




    shape = newsCorpus.get_shape()
    dim_row = shape[0]
    dim_col = shape[1]
    max_size = dim_row*dim_col
    non_zero_ele = newsCorpus.count_nonzero()
    MBsize = non_zero_ele * 8/1024/1024
    MBsize_dense = dim_col * dim_row * 8/1024/1024

    print("Matrix dimensions: D x W = {} x {} = {}".format(dim_row, dim_col, max_size))
    print("Vocab size: V = {}".format(len(vocab)))
    print("Non zero elements: {} (sparse storage)".format(non_zero_ele))
    print("Size estimation (sparse): {} MB".format(MBsize))
    print("Size estimation (dense): {} MB".format(MBsize_dense))

    processLightLDA(newsCorpus, vocab, outputdir)
    #processLDApp(newsCorpus, vocab, outputdir)
    #processParaLDA(newsCorpus, vocab, outputdir)
    processPLDA(newsCorpus, vocab, outputdir)

    

if __name__ == "__main__":
    main()


