import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import seaborn as sns
from sklearn.cluster import KMeans
from scipy.cluster.vq import kmeans, vq
from sklearn.metrics import silhouette_score

k_max = 30

def RatingDist(rating):
    sns.displot(rating, bins=20)
    plt.show()

def scatterPlot(x=None, y=None, lable:str='Not labled'):
    if x is not None and y is not None:
        ax = plt.scatter(x, y, c='DarkBlue')
        plt.title(lable) 
        plt.show()

#The Silhouette Method
def SilK(x=None, y=None, plot:bool=False):
    opt_k = -1
    if x is not None and y is not None:
        data = np.asarray([np.asarray(x), np.asarray(y)]).T
        sil_points = []
        opt_k = 1
        max_sil:float = -2.0 # A silhouette_score is always [-1,1]
        
        for k in range(2, k_max):
            k_means = KMeans(n_clusters = k)
            k_means.fit(data)
            labels = k_means.labels_
            score = silhouette_score(data, labels, metric = 'euclidean')
            
            if score > max_sil:
                max_sil = score
                opt_k = k
            
            if plot == True:
                sil_points.append(score)
        
        if plot == True:
            fig = plt.figure(figsize=(15,10))
            plt.plot(range(2,30), sil_points, 'bx-')
            plt.title("Silhouette Curve")
            plt.show()

    return opt_k


def elbowGraphKmean(x=None, y=None):
     if x is not None and y is not None:
        data = np.asarray([np.asarray(x), np.asarray(y)]).T
        distortions = []
        for k in range(2, k_max):
            k_means = KMeans(n_clusters = k)
            k_means.fit(data)
            distortions.append(k_means.inertia_)
        
        fig = plt.figure(figsize=(15,10))
        plt.plot(range(2,k_max), distortions, 'bx-')
        plt.title("Elbow Curve")
        plt.show()

def sactterPlotKmeanLables(x=None, y=None, k=None):
    if x is not None and y is not None and k is not None:
        data = np.asarray([np.asarray(x), np.asarray(y)]).T
        centroids, _ = kmeans(data, k)

        #assigning each sample to a cluster
        #Vector Quantisation:

        idx, _ = vq(data, centroids)

        sns.set_context('paper')
        plt.figure(figsize=(15,10))
        plt.plot(data[idx==0,0],data[idx==0,1],'or',#red circles
             data[idx==1,0],data[idx==1,1],'ob',#blue circles
             data[idx==2,0],data[idx==2,1],'oy', #yellow circles
             data[idx==3,0],data[idx==3,1],'om', #magenta circles
             data[idx==4,0],data[idx==4,1],'ok',#black circles        
                )
        plt.plot(centroids[:,0],centroids[:,1],'sg',markersize=8, )

        circle1 = Line2D(range(1), range(1), color = 'red', linewidth = 0, marker= 'o', markerfacecolor='red')
        circle2 = Line2D(range(1), range(1), color = 'blue', linewidth = 0,marker= 'o', markerfacecolor='blue')
        circle3 = Line2D(range(1), range(1), color = 'yellow',linewidth=0,  marker= 'o', markerfacecolor='yellow')
        circle4 = Line2D(range(1), range(1), color = 'magenta', linewidth=0,marker= 'o', markerfacecolor='magenta')
        circle5 = Line2D(range(1), range(1), color = 'black', linewidth = 0,marker= 'o', markerfacecolor='black')

        plt.legend((circle1, circle2, circle3, circle4, circle5)
                   , ('Cluster 1','Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5'), numpoints = 1, loc = 0, )
        plt.show()


