#!/usr/bin/env python3

import pandas as pd

pre_movies = pd.read_csv("output/split_genre.csv")
pre_ratings = pd.read_csv("output/avg_movie.csv")

# (SQL) Join both tables and then drop movieId
df = pd.merge(pre_movies, pre_ratings, on = 'movieId').drop("movieId",axis = 1)

# Group by genre and compute mean of ratings
df = pd.DataFrame(df.groupby("genres")['rating'].mean()).sort_values(by=['rating'], ascending = False)

# Rename column for convenience
df = df.rename(columns={'rating': 'Last Week Rating'})

print(df)
