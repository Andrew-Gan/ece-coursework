import numpy as np
import pandas as pd
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split
from sklearn import linear_model
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt

class MeanStdObj:
    def __init__(self):
        self.mean = []
        self.std = []

def main():
    #Importing dataset
    diamonds = pd.read_csv('diamonds.csv')
    #Feature and target matrices
    X = diamonds[['carat', 'depth', 'table', 'x', 'y', 'z', 'clarity', 'cut', 'color']]
    y = diamonds[['price']]
    #Normalizing X and test input
    X, myObj = normalize(X)
    #Training and testing split, with 25% of the data reserved as the test set
    [X_train, X_test, y_train, y_test] = train_test_split(X, y, test_size=0.25, random_state=101)
    #Define the range of lambda to test
    lmbda = np.linspace(0.1, 1.0, 10).tolist() + np.linspace(1.5, 10, 18).tolist() + np.linspace(11, 100, 90).tolist()
    lmbda = [round(i, 2) for i in lmbda]
    MODEL = []
    MSE = []
    for l in lmbda:
        #Train the regression model using a regularization parameter of l
        model = train_model(X_train,y_train,l)

        #Evaluate the MSE on the test set
        mse = error(X_test,y_test,model)

        #Store the model and mse in lists for further processing
        MODEL.append(model)
        MSE.append(mse)
    #Plot the MSE as a function of lmbda
    plt.plot(lmbda, MSE)
    plt.xlabel('lmbda')
    plt.ylabel('MSE')
    plt.show()
    #Find best value of lmbda in terms of MSE
    ind = MSE.index(min(MSE))
    [lmda_best,MSE_best,model_best] = [lmbda[ind],MSE[ind],MODEL[ind]]
    print('Best lambda tested is ' + str(lmda_best) + ', which yields an MSE of ' + str(MSE_best))

    get_res(model_best, myObj)
    return model_best, myObj

#Function that normalizes features to zero mean and unit variance.
#Input: Feature matrix X.
#Output: X, the normalized version of the feature matrix.
def normalize(X):
    X = X.to_numpy()
    myObj = MeanStdObj()
    for i in range(len(X[0])):
        myObj.mean.append(np.mean(X[:,i]))
        myObj.std.append(np.std(X[:,i]))
        X[:,i] = np.divide(np.subtract(X[:,i], np.mean(X[:,i])), np.std(X[:,i]))
    return X, myObj

#Function that trains a ridge regression model on the input dataset with lambda=l.
#Input: Feature matrix X, target variable vector y, regularization parameter l.
#Output: model, a numpy object containing the trained model.
def train_model(X,y,l):
    return Ridge(alpha=l, fit_intercept=True).fit(X, y)

#Function that calculates the mean squared error of the model on the input dataset.
#Input: Feature matrix X, target variable vector y, numpy model object
#Output: mse, the mean squared error
def error(X,y,model):
    return mean_squared_error(y, model.predict(X))

def get_res(model, myObj):
    print('Coefs = ' + str(model.coef_))
    test_list = np.asarray([0.25, 60, 55, 4, 3, 2, 5, 3, 3])
    test_list = np.divide(np.subtract(test_list, np.asarray(myObj.mean)), np.asarray(myObj.std))
    test_list = test_list.reshape((1, -1))
    res = round(model.predict(test_list)[0][0], 2) + model.intercept_
    print('predicted value = ' + str(res))

if __name__ == '__main__':
    model = main()