import numpy as np
import matplotlib.pyplot as plt

#Return fitted model parameters to the dataset at datapath for each choice in degrees.
#Input: datapath as a string specifying a .txt file, degrees as a list of positive integers.
#Output: paramFits, a list with the same length as degrees, where paramFits[i] is the list of
#coefficients when fitting a polynomial of n = degrees[i].
def main(datapath, degrees):
    fp = open(datapath, "r")
    xSet = []
    ySet = []
    newLine = fp.readline()
    while(newLine != '' and len(newLine.split()) == 2):
        xSet.append(float(newLine.split()[0]))
        ySet.append(float(newLine.split()[1]))
        newLine = fp.readline()
    paramFits = []
    for n in degrees:
        paramFits.append(least_squares(feature_matrix(xSet, n), ySet))
    fp.close()
    plot_data(xSet, ySet, paramFits)
    print('x = 2, y = %.6f' %np.polyval(paramFits[2], 2))
    return paramFits

#Return the feature matrix for fitting a polynomial of degree n based on the explanatory variable
#samples in x.
#Input: x as a list of the independent variable samples, and n as an integer.
#Output: X, a list of features for each sample, where X[i][j] corresponds to the jth coefficient
#for the ith sample. Viewed as a matrix, X should have dimension #samples by n+1.
def feature_matrix(x, n):
    return [[i**j for j in range(n, -1, -1)] for i in x]

#Return the least squares solution based on the feature matrix X and corresponding target variable samples in y.
#Input: X as a list of features for each sample, and y as a list of target variable samples.
#Output: B, a list of the fitted model parameters based on the least squares solution.
def least_squares(X, y):
    B = np.linalg.lstsq(np.array(X), np.array(y), rcond=None)[0].tolist()
    return [round(i, 6) for i in B]

def plot_data(xSet, ySet, paramfits):
    plt.scatter(xSet, ySet)
    xSet = np.linspace(-5, 15, 100)
    for param in paramfits:
        ySet = np.polyval(param, xSet)
        plt.plot(xSet, ySet)
    plt.legend(['n=1', 'n=2', 'n=3', 'n=4', 'n=5', 'original'])
    plt.show()

if __name__ == '__main__':
    datapath = 'poly.txt'
    #degrees = [2, 4]
    degrees = range(1, 6, 1)

    paramFits = main(datapath, degrees)
    print(paramFits)
