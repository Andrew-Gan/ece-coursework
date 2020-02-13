import numpy as np
from scipy.stats import norm
from gmm_visualize import extCall

#function which carries out the expectation step of expectation-maximization
def expectation(data, weights, means, varis):
    k = len(means)
    N = len(data)
    gammas = np.zeros((k,N))

    #fill in here
    #code to calculate each gamma = gammas[i][j], the likelihood of datapoint j in gaussian i, from the
    #current weights, means, and varis of the gaussians
    for i in range(k):
        gammas[i,:] = np.multiply(weights[i], [norm(means[i], pow(varis[i], 0.5)).pdf(data[j]) for j in range(N)])
    gammas = gammas / np.sum(gammas, axis=0)
    return gammas


#function which carries out the maximization step of expectation-maximization
def maximization(data, gammas):
    k = len(gammas)

    #fill in here
    #code to calculate each (i) weight = weights[i], the weight of gaussian i, (ii) mean = means[i], the
    #mean of gaussian i, and (iii) var = varis[i], the variance of gaussian i, from the current gammas of the
    #datapoints and gaussians
    weights = np.asarray([np.sum(gammas[i,:]) / np.sum(gammas) for i in range(k)])
    means = np.asarray([np.sum(np.multiply(data, gammas[i,:])) / sum(gammas[i,:])  for i in range(k)])
    varis = np.asarray([np.sum(np.multiply(gammas[i,:], np.power(np.subtract(data, means[i]), 2))) / sum(gammas[i,:])  for i in range(k)])
    return weights, means, varis


#function which trains a GMM with k clusters until expectation-maximization returns a change in log-likelihood of less
#than a tolerance tol
def train(data, k, tol):
    # fill in
    # initializations of gaussian weights, means, and variances according to the specifications
    weights = [1 / k] * k
    means = [min(data) + i * (max(data) - min(data)) / k for i in range(k)]
    varis = [1] * k

    diff = float("inf")
    ll_prev = -float("inf")

    # iterate through expectation and maximization procedures until model convergence
    while(diff >= tol):
        gammas = expectation(data, weights, means, varis)
        weights, means, varis = maximization(data, gammas)
        ll = log_likelihood(data,weights,means,varis)
        diff = abs(ll - ll_prev)
        ll_prev = ll

    return weights, means, varis, ll


#calculate the log likelihood of the current dataset with respect to the current model
def log_likelihood(data, weights, means, varis):
    #fill in
    ll = np.sum([np.log(np.sum([np.multiply(weights[i], norm(means[i], np.power(varis[i], 0.5)).pdf(data[j])) for i in range(len(means))])) for j in range(len(data))])
    return ll


def main(datapath, k, tol):
    #read in dataset
    with open(datapath) as f:
        data = f.readlines()
    data = [float(x) for x in data]
    #train mixture model
    weights, means, varis, ll = train(data, k, tol)

    return weights,means,varis,ll

if __name__ == '__main__' :
    for k in [2, 3, 4, 5, 6]:
        weights, means, varis, ll = main('data.txt', k, 1)
        print('k = ' + str(k))
        for i in range(k):
            print(str(round(weights[i], 3)) + ' ' + 'N(x | ' + str(round(means[i], 3)) + ', ' + str(round(varis[i], 3)) + ')', end='')
            if(i == k-1):
                print()
            else:
                print(' + ', end='')
        print('ll = ' + str(round(ll, 4)))
        extCall(weights, means, varis)