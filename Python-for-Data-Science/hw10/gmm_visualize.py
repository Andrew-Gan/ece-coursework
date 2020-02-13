import numpy as np
from scipy.stats import norm
import matplotlib.pyplot as plt


#function which computes a gaussian model with mean mu and variance var on the data array x
def gauss(x, mu, var):
    #fill in
    p = norm(mu, np.power(var, 0.5)).pdf(x)
    return p

#function which uses plt to plot the individual clusters and the full mixture model on a single chart
def plot_model(x, clusters, model):
    #fill in
    legendlist = ['model']
    plt.plot(model)
    i = 1
    for clus in clusters:
        plt.plot(clus)
        legendlist.append('cluster ' + str(i))
        i += 1
    plt.title('Clusters and Gaussian Mixture Model for k = ' + str(len(clusters)))
    plt.xlabel('Data')
    plt.ylabel('PDF')
    plt.legend(legendlist)
    plt.show()

def main(weights, means, varis):
    #find range of inputted mixture model to be plotted
    [gmin, gmax] = [np.argmin(means), np.argmax(means)]
    xmin = means[gmin] - 4*np.sqrt(varis[gmin])
    xmax = means[gmax] + 4*np.sqrt(varis[gmax])

    #define range of 1000 points based on xmin and xmax
    inc = (xmax - xmin) / 1000
    x = np.arange(xmin,xmax+inc,inc)
    k = len(means)
    clusters = []   #a list of each component (gaussian) in the mixture applied to the vector x
    model = np.zeros(len(x))    #total mixture model applied to the vector x
    for i in range(k):
        p_i = gauss(x,means[i],varis[i])
        clusters.append(np.multiply(weights[i], p_i))
        model = np.add(model, clusters[i])

    #plot the results
    plot_model(x,clusters,model)

def extCall (weights, means, varis):
    main(weights, means, varis)