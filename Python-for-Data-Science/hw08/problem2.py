from hw8_1 import getDict
from helper import plotHisto

def main():
    filenames = [   'english', 
                    'french', 
                    'german', 
                    'italian', 
                    'mystery', 
                    'portuguese', 
                    'spanish',
                ]

    ngramList = set()
    ngramDict = list(map(getDict, ['ngrams/' + i + '.txt' for i in filenames]))
    for i in range(len(filenames)):
        ngramList.update(list(ngramDict[i].keys()))
    ngramList = sorted(list(ngramList))
    ngramFreq = [[0]*len(ngramList) for j in range(len(filenames))]
    for k in range(len(filenames)):
        for l in ngramDict[k].keys():
            ngramFreq[k][ngramList.index(l)] = ngramDict[k][l]
    
    for m in range(len(filenames)):
        plotHisto(ngramFreq[m], filenames[m] + '.png')

if __name__ == '__main__' :
    main()