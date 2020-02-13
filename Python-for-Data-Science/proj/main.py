from kmeans import kmeansExtCall
from regularize import regExtCall
import numpy as np
from math import floor
import matplotlib.pyplot as plt

def parse(filename):
    # open file, throws exception if file invalid
    try:
        fp = open(filename)
    except FileNotFoundError:
        raise FileNotFoundError

    # holds info regarding student behavior
    data = {}
    vid_train_x = {}
    vid_train_y = {}
    
    # sum up features for each student in dictionary
    firstLine = True
    for line in fp:
        if firstLine:
            firstLine = False
        else:
            lineArgs = line.split()
            # get rid of unnecessary values and group by student ID
            if lineArgs[0] not in data:
                data[lineArgs[0]] = np.concatenate(([1], lineArgs[2:4], lineArgs[5:8], lineArgs[9:])).astype(float)
            else:
                data[lineArgs[0]] += np.concatenate(([1], lineArgs[2:4], lineArgs[5:8], lineArgs[9:])).astype(float)
            # get rid of unnecessary values and group by video ID
            if int(lineArgs[1]) not in vid_train_x:
                list = lineArgs[2:4] + lineArgs[5:8] + lineArgs[9:11]
                vid_train_x[int(lineArgs[1])] = [[float(k) for k in list]]
                vid_train_y[int(lineArgs[1])] = [float(lineArgs[11])]
            else:
                list = lineArgs[2:4] + lineArgs[5:8] + lineArgs[9:11]
                vid_train_x[int(lineArgs[1])].append([float(k) for k in list])
                vid_train_y[int(lineArgs[1])].append(float(lineArgs[11]))

    # convert data into numpy ndarray and divide features by number of videos watched for that student
    # each student is a data point
    data = np.asarray([np.concatenate(([r[0]], np.divide(r[1:], r[0]))).tolist() for r in data.values()])

    totalVidCount = len(vid_train_x)
    # select students with vid count >=5
    # discard student ID and y values
    cluster_val = np.asarray([k[1:8] for k in data if k[0] >= 5])
    
    # select students with vid count >=total_vid_count/2
    # discard student ID
    predict_val = np.asarray([k[1:9] for k in data if k[0] >= totalVidCount / 2])

    # predicting average performance
    # 90% data used for training ridge model
    train_x = np.asarray([k[0:7] for k in predict_val])
    train_y = np.asarray([k[7] for k in predict_val])

    return cluster_val, train_x, train_y, vid_train_x, vid_train_y

def cluster(cluster_val, numFeature, numCluster):
    avgDist = []
    diffDist = []
    sumDist = 0
    print('Clustering {} students by given behavioral features' .format(len(cluster_val)))
    for i in numCluster:
        initClusters = [[0]*numFeature for k in range(i)]
        clusters = kmeansExtCall(cluster_val, initClusters)
        for c in clusters:
            if(len(c.points) is not 0):
                sumDist += c.avgDistance
        if(i == 20):
            bestCluster = clusters
        avgDist.append(sumDist / i)
        sumDist = 0
    
    for c in bestCluster:
        c.printAllPoints()
    
    for c in clusters:
        for p in c.points:
            diffDist.append(p.distfrom(p.closest()) - p.distfrom(p.secondClosest()))
    diffDist = np.divide(sum(diffDist), len(diffDist))
    print(diffDist)
    return avgDist, numCluster, diffDist

def predict_avg(train_x, train_y):
    model, mse, lmd, lmdArr, mseArr = regExtCall(train_x, train_y)
    test_x = train_x[int(len(train_x) * 0.9):]
    predicted_y = model.predict(test_x)
    actual_y = train_y[int(len(train_y) * 0.9):]
    thres = 0.2
    numCorr = sum(abs(predicted_y - actual_y) < thres)
    print('\nPredicting students by given behavioral features')
    print('Training Data: {}\nTesting Data:{}' .format(len(train_x), len(test_x)))
    print('Threshold Value: %.1f' %thres)
    print('Model Accuracy: %.2f %%' %(numCorr / len(actual_y) * 100))
    print('Model Coefficients: {}' .format(model.coef_))
    print('MSE : %.2f' %mse)
    print('R^2 : %.2f' %(model.score(test_x, actual_y)))
    print('Best Lambda Value: {}\n' .format(lmd))
    return lmdArr, mseArr

def predict_vid(vid_train_x, vid_train_y):
    print('Predicting video performance by given behavioral features')
    thres = 0.2
    vidID = []
    vidAcc = []
    mseArr = []
    print('Threshold value = {}' .format(thres))
    for i in range(len(vid_train_x)):
        if i in vid_train_x:
            vidID.append(i)
            model, mse, lmd, null, null = regExtCall(np.asarray(vid_train_x[i]), np.asarray(vid_train_y[i]))
            test_x = vid_train_x[i][int(len(vid_train_x[i]) * 0.9):]
            predicted_y = model.predict(test_x)
            actual_y = vid_train_y[i][int(len(vid_train_x[i]) * 0.9):]
            corrCount = sum(abs(predicted_y - actual_y < thres))
            print('Video ID : {}' .format(i))
            print('Accuracy : %0.2f %%' %(corrCount / len(predicted_y) * 100))
            vidAcc.append(corrCount / len(predicted_y))
            print('MSE : %.2f' %mse)
            mseArr.append(mse)
            print('Best Lambda Value : {}\n' .format(lmd))
    return vidID, vidAcc, mseArr

def plot_graphs(numCluster, avgDist, lmdArr, mseArr, vidID, vidAcc, vid_mseArr):
    # plot for prob 1 : avg dist for each cluster
    plt.xlabel('Number of clusters')
    plt.ylabel('Average Distance of Points to Cluster')
    plt.title('Average Distance of Points to Cluster over Different Number of Clusters')
    plt.plot(numCluster, avgDist)
    plt.show()
    # plot for prob 2 : lambda values for predicting student performance
    plt.xlabel('Lambda')
    plt.ylabel('MSE')
    plt.title('MSE values over Different Lambdas when Training Model')
    plt.plot(lmdArr, mseArr)
    plt.show()
    # plot for prob 3 : prediction accuracy for each video
    plt.bar(vidID, vidAcc)
    plt.title('Accuracy of Model in Predicting Each Video ID')
    plt.xlabel('Video ID')
    plt.ylabel('Prediction Accuracy')
    plt.show()
    # plot for prob 3 : model MSE for each video
    plt.bar(vidID, vid_mseArr)
    plt.title('MSE of Model in Predicting Each Video ID')
    plt.xlabel('Video ID')
    plt.ylabel('MSE')
    plt.show()

def main():
    # check if file path is valid
    # filter out values that do not meet specified conditions
    try:
        cluster_val, train_x, train_y, vid_train_x, vid_train_y = parse('behavior-performance.txt')
    except FileNotFoundError:
        print('Invalid file path')
        return
    
    # question 1: clustering
    avgDist, numCluster, diffDist = cluster(cluster_val, 7, range(10, 30, 10))

    # # question 2: generalized prediction
    # lmdArr, mseArr = predict_avg(train_x, train_y)
    
    # # question 3: specific prediction
    # vidID, vidAcc, vid_mseArr = predict_vid(vid_train_x, vid_train_y)

    # # plot all graphs
    # plot_graphs(numCluster, avgDist, lmdArr, mseArr, vidID, vidAcc, vid_mseArr)

if __name__ == '__main__' :
    main()