import numpy as np
import matplotlib.pyplot as plt
from helper import *
import problem2

#change a histogram of counts into a histogram of probabilities
#input: a histogram (like your histogram function creates)
#output: a normalized histogram with probabilities instead of counts
def norm_histogram(hist) :
    #fill in
    #hint: when doing your normalization, you should convert the integers
    #      in your histogram buckets to floats: float(x)
    totalCount = sum(hist)
    norm_hist = [0] * len(hist)
    i = 0
    for k in hist:
        prob = float(k) / totalCount
        norm_hist[i] = prob
        i = i + 1
    return norm_hist
    
#compute cross validation for one bin width
#input: a (non-normalized) histogram and a bin width
#output: the cross validation score (J) for the specified width
def crossValid (histo, width) :
    #1. build the list of probabilities
    histProb = norm_histogram(histo)
    #2. compute the sum of the squares of the probabilities
    sumSqr = 0
    for k in histProb:
        sumSqr = sumSqr + (k ** 2)
    #3. determine the total number of points in the histogram
    #   hint: look up the Python "sum" function
    numPoints = sum(histo)
    #4. Compute J(h) and return it
    n = 1000
    J = 2 / ((n - 1) * width) - (n + 1) / ((n - 1) * width) * sumSqr
    return J
    
#sweep through the range [min_bins, max_bins], compute the cross validation
#score for each number of bins, and return a list of all the Js
#Note that the range is inclusive on both sides!
#input: the dataset to build a histogram from
#       the minimum value in the data set
#       the maximum value in the data set
#       the smallest number of bins to test
#       the largest number of bins to test
#output: a list (of length max_bins - min_bins + 1) of all the appropriate js
def sweepCross (data, minimum, maximum, min_bins, max_bins) :
    #fill in. Don't forget to convert from a number of bins to a width!
    i = 0
    js = [0] * (max_bins - min_bins + 1)
    for numBin in range(min_bins, max_bins + 1):
        histo = [0] * numBin
        (histo, width) = homework2.histogram(data, numBin, minimum, maximum)
        js[i] = crossValid(histo, width)
        i = i + 1
    return js
        
#return the minimum value in a list *and* the index of that value
#input: a list of numbers
#output: a tuple with the first element being the minimum value, and the second 
#        element being the index of that minumum value (if the minimum value is 
#        in the list more than once, the index should be the *first* occurence 
#         of that minimum value)
def findMin (l) :
    #fill in.
    minVal = min(l)
    minIndex = l.index(minVal)
    return (minVal, minIndex)
        
if __name__ == '__main__' :
        #Sample test code
        data = getData() #reads data from inp.txt
        lo = min(data)
        hi = max(data)
        
        js = sweepCross(data, lo, hi, 1, 100)
        print(findMin(js))
