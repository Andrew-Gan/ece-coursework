import numpy as np
import matplotlib.pyplot as plt
import string

#bars: list of length number of bins, with each entry having its histogram value
#filename: file to save plot to (in .png format)
#minrange: minimum value of leftmost bin
#maxrange: maximum value of rightmost bin

def plotHisto (bars, filename, minrange = 0.0, maxrange = 100.0, plotinline = False) :
	mrange = maxrange - minrange
	binsize = mrange/len(bars)
	
	#this is a "list comprehension" -- it's a quick way to process one
	#list to produce another list
	labels = [(mrange / len(bars)) * i + minrange for i in range(len(bars))]
	
	plt.bar(labels, bars, align = 'edge', width = binsize)
	if plotinline :
		plt.show()
	else :
		plt.savefig(filename)
		# plt.show()
		plt.clf()

#Input: words -- a list of words, including some words that might be punctuation
#Output: list of words *without* the words that might be punctuation
def remove_punc(words) :
    return [w for w in words if w not in string.punctuation]
    
if __name__ == "__main__" :
    import nltk
    import nltk.tokenize as tk
    
    nltk.download("punkt")
    
    teststring = "Tyger Tyger, burning bright, In the forests of the night; What immortal hand or eye, Could frame thy fearful symmetry?"
    words = tk.word_tokenize(teststring)
    
    print(words)
    
    print(remove_punc(words))