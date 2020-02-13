import scipy.stats as stats
import matplotlib.pyplot as plt
import numpy as np
import csv

def main():
    dist_type = ['norm', 'cauchy', 'cosine', 'expon', 'uniform', 'laplace', 'wald', 'rayleigh']
    file_names = ['distA', 'distB', 'distC']
    for n in file_names:
        fp = open(n + '.csv')
        csv_file = csv.reader(fp)
        ls = []
        for k in csv_file:
            ls.append(float(k[0]))
        plotDistr(n, ls, dist_type)
        fp.close()

def plotDistr(dataSet, ls, dist_type):
    for m in dist_type:
        stats.probplot(ls, dist = m, plot=plt)
        file_name = dataSet + ' - ' + m + '.png'
        plt.savefig(file_name)

main()
