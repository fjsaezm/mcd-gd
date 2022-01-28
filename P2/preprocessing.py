#!/usr/bin/env python3

import pandas as pd
import numpy as np
from sklearn.pipeline import Pipeline
import time
from sklearn.preprocessing import FunctionTransformer

# Read data
movies = pd.read_csv("input/movies.csv")
ratings = pd.read_csv("input/ratings.csv")

# ----------- AUXILIAR FUNCTIONS ------------------

# Function to save a dataframe in a Pipeline
save = lambda df,name : df.to_csv(name, index = False)

## Functions for the ratings csv

week = 60*60*24*7
# Function that removes the data older than 1 week
filter_date = lambda df, n_weeks = 1 : df[df['timestamp'] > time.time() - n_weeks *week ]

# Function that removes rows that have a null value
remove_nulls = lambda df : df.dropna().drop_duplicates()

# Function that removes wrong evaluations
def remove_wrong_evaluations(df):
    correct_vals = np.arange(0.5, 5.01, 0.5)
    return df[df['rating'].isin(correct_vals)]

# Functions that computes mean per film
mean_per_id = lambda df: df.groupby('movieId')['rating'].mean()

## Functions for the movies csv

# Remove nulls
def remove_null_genres(df):
    return df[df.genres != '(no genres listed)']

# Split the movies by its genres
def split_genres(df):
    df['genres'] = df['genres'].apply(lambda x : x.split("|"))
    return df.explode('genres')



# --------- PIPELINES DECLARATION --------------

average_rating_pipeline = Pipeline([
                            ('date_filter',FunctionTransformer( func = filter_date, kw_args = {'n_weeks': 120})),
                            ('remove_nulls',FunctionTransformer(func = remove_nulls)),
                            ('remove_wrong_evaluations',FunctionTransformer(func = remove_wrong_evaluations)),
                            ('compute_mean_id',FunctionTransformer(func = mean_per_id)),
                            ('save',FunctionTransformer( func = save, kw_args = {'name': "output/avg_movie.csv"}))
                            ])

movie_genre_pipe = Pipeline([
                            ('date_filter',FunctionTransformer( func = remove_null_genres)),
                            ('remove_nulls',FunctionTransformer(func = remove_nulls)),
                            ('split_genres',FunctionTransformer(func = split_genres)),
                            ('save',FunctionTransformer( func = save, kw_args = {'name': "output/split_genre.csv"})),
])


# -------------- PIPELINES APPLICATION -----------


average_rating_pipeline.transform(ratings)

movie_genre_pipe.transform(movies)
