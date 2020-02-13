#Arguments:
#  filename: name of file to read in
#Returns: a list of strings, each string is one line in the file
def getText(filename) :
    strList = []
    fp = open(filename, "r")
    line = fp.readline()
    while(line != ''):
        strList.append(line)
        line = fp.readline()
    fp.close()
    return strList

#Arguments:
#  line: a string of text
#Returns: a list of n-grams
def getNgrams(line) :
    ngramList = ('_' + line.lower() + '_')
    ngramList = [ngramList[i:i+3] for i in range(len(ngramList))]
    return ngramList
    
#Arguments:
#  filename: the filename to create an n-gram dictionary for
#Returns: a dictionary, with ngrams as keys, and frequency of that ngram as the value.
def getDict(filename) :
    strList = getText(filename)
    ngramList = [item for subList in map(getNgrams, strList) for item in subList]
    ngramDict = dict.fromkeys(ngramList, 0)
    for i in range(len(ngramList)):
        ngramDict[ngramList[i]] = ngramDict[ngramList[i]] + 1
    return ngramDict