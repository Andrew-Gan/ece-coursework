from cluster import *
from point import *

def kmeans(pointdata, clusterdata) :
    #Fill in
    
    #1. Make lists of points and clusters using makePointList and createClusters
    points = makePointList(pointdata)
    clusters = createClusters(clusterdata)
    
    #2. As long as points keep moving:
    changedCluster = True
    while(changedCluster == True):
        #A. Move every point to its closest cluster (use Point.closest and
        #   Point.moveToCluster
        #   Hint: keep track here whether any point changed clusters by
        #         seeing if any moveToCluster call returns "True"
        changedCluster = False
        for p in points:
            changedCluster = p.moveToCluster(p.closest(clusters)) or changedCluster
        #B. Update the centers of each cluster (use Cluster.updateCenter)    
        for c in clusters:
            c.updateCenter()
            
    #3. Return the list of clusters, with the centers in their final positions
    return clusters
    
if __name__ == '__main__' :
    data = np.array([[0.5, 2.5], [0.3, 4.5], [-0.5, 3], [0, 1.2], [10, -5], [11, -4.5], [8, -3]], dtype=float)
    centers = np.array([[0, 0], [1, 1]], dtype=float)
    
    clusters = kmeans(data, centers)
    for c in clusters :
        c.printAllPoints()