from helper import remove_punc
import nltk
import numpy as np

#Clean and lemmatize the contents of a document
#Takes in a file name to read in and clean
#Return a list of words, without stopwords and punctuation, and with all words lemmatized
# NOTE: Do not append any directory names to doc -- assume we will give you
# a string representing a file name that will open correctly
def readAndCleanDoc(doc) :
    #1. Open document, read text into *single* string
    fp = open(doc, "r")
    words = fp.read()
    fp.close()
    #2. Tokenize string using nltk.tokenize.word_tokenize
    words = nltk.tokenize.word_tokenize(words)
    #3. Filter out punctuation from list of words (use remove_punc)
    words = remove_punc(words)
    #4. Make the words lower case
    words = [w.lower() for w in words]
    #5. Filter out stopwords
    stopwords_en = set(nltk.corpus.stopwords.words('english'))
    words = [k for k in words if not k in stopwords_en]
    #6. Lemmatize words
    lemmatizer = nltk.stem.WordNetLemmatizer()
    words = [lemmatizer.lemmatize(w) for w in words]
    return words
    
#Builds a doc-word matrix for a set of documents
#Takes in a *list of filenames*
#
#Returns 1) a doc-word matrix for the cleaned documents
#This should be a 2-dimensional numpy array, with one row per document and one 
#column per word (there should be as many columns as unique words that appear
#across *all* documents
#
#Also returns 2) a list of words that should correspond to the columns in
#docword
def buildDocWordMatrix(doclist) :
    #1. Create word lists for each cleaned doc (use readAndCleanDoc)
    words = list(map(readAndCleanDoc, doclist))
    wordlist = set()
    wordlist.update([w for l in words for w in l])
    wordlist = list(wordlist)
    #2. Use these word lists to build the doc word matrix
    docword = np.asarray([[words[r].count(w) for w in wordlist] for r in range(len(doclist))])
    return docword, wordlist
    
#Builds a term-frequency matrix
#Takes in a doc word matrix (as built in buildDocWordMatrix)
#Returns a term-frequency matrix, which should be a 2-dimensional numpy array
#with the same shape as docword
def buildTFMatrix(docword) :
    tf = [np.true_divide(r, np.sum(r)) for r in docword]
    return tf
    
#Builds an inverse document frequency matrix
#Takes in a doc word matrix (as built in buildDocWordMatrix)
#Returns an inverse document frequency matrix (should be a 1xW numpy array where
#W is the number of words in the doc word matrix)
#Don't forget the log factor!
def buildIDFMatrix(docword) :
    idf = [sum(1 for i in docword[:,w] if i > 0) for w in range(len(docword[0]))]
    return idf
    
#Builds a tf-idf matrix given a doc word matrix
def buildTFIDFMatrix(docword) :
    tfidf = np.multiply(buildTFMatrix(docword), buildIDFMatrix(docword))  
    return tfidf
    
#Find the three most distinctive words, according to TFIDF, in each document
#Input: a docword matrix, a wordlist (corresponding to columns) and a doclist 
# (corresponding to rows)
#Output: a dictionary, mapping each document name from doclist to an (ordered
# list of the three most common words in each document
def findDistinctiveWords(docword, wordlist, doclist) :
    distinctiveWords = {}
    wordlist = np.asarray(wordlist)
    tfidf = buildTFIDFMatrix(docword)
    distinctiveWords.update({d:wordlist[r.argsort()[-3:][::-1]].tolist() for (d, r) in zip(doclist, tfidf)})
    return distinctiveWords