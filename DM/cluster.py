import numpy as np 
import pandas as pd
import os
import matplotlib.pyplot as plt
from sklearn import neighbors
from sklearn.preprocessing import MinMaxScaler
import json

class Cluster:
    def __init__(self, df:object):
        self.df = df
        self.k = 6
        self.books_features = pd.concat([df['Ratings_Dist'].str.get_dummies(sep=","), df['rating'], df['numRatings']], axis=1)
        self.indices:np.ndarray 
        self.distance:np.ndarray 

    def training(self):
        min_max_scaler = MinMaxScaler()
        self.books_features = min_max_scaler.fit_transform(self.books_features)
        np.round(self.books_features, 2)
        model = neighbors.NearestNeighbors(n_neighbors=self.k, algorithm='kd_tree')
        model.fit(self.books_features)
        self.distance, self.indices = model.kneighbors(self.books_features)
   
    def get_index_from_name(self, name):
        return self.df[self.df["Name"]==name].index.tolist()[0]

    def get_id_from_partial_name(self, partial):
        all_books_names = list(self.df.Name.values)
        for name in list(self.df.Name.values):
            if partial in name:
                print(name,"Index of book = {}\n".format(all_books_names.index(name)))
                
    def print_similar_books(self, name=None,id=None):
        try:
            if id:
                for id in self.indices[id][1:]:
                    print(self.df.iloc[id]["Name"])
            if name:
                found_id = self.get_index_from_name(name)
                for id in self.indices[found_id][1:]:
                    print(self.df.iloc[id]["Name"])
        except IndexError:
            print("No Book by the name \"{}\" found in the database".format(name))
    
