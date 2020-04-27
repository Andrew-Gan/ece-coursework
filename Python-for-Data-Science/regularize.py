import numpy as np
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split
from sklearn import linear_model
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt

class MeanStdObj:
    def __init__(self):
        self.mean = []
        self.std = []

def regExtCall(X, y):
    #Normalizing X and test input
    X, myObj = normalize(X)
    #Training and testing split, with 25% of the data reserved as the test set
    [X_train, X_test, y_train, y_test] = train_test_split(X, y, test_size=0.1, random_state=101)
    #Define the range of lambda to test
    lmbda = np.linspace(-12, 100, 1000).tolist()
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
    #Find best value of lmbda in terms of MSE
    ind = MSE.index(min(MSE))

    return MODEL[ind], min(MSE), lmbda[ind], lmbda , MSE

#Function that normalizes features to zero mean and unit variance.
#Input: Feature matrix X.
#Output: X, the normalized version of the feature matrix.
def normalize(X):
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