import pandas as pd
import numpy as np
import sys
import csv

# pass in column names for each CSV as the column name is not given in the file and read them using pandas.
# You can check the column names from the readme file
# Reading users file:
u_cols = ['user_id', 'age', 'sex', 'occupation', 'zip_code', 'user_name', 'password']
users = pd.read_csv('ml-100k/u.user', sep='|', names=u_cols, encoding='latin-1', dtype={'password': str})

user_id = users[(users['user_name'] == sys.argv[1]) & (users['password'] == sys.argv[2])].user_id.unique()
user_genres = ""

if user_id.shape[0] == 1:
    input_user_id = user_id[0]
    r_cols = ['user_id', 'movie_id', 'rating', 'unix_timestamp']
    ratings = pd.read_csv('ml-100k/u.data', sep='\t', names=r_cols, encoding='latin-1')
    
    i_cols = ['movie_id', 'title', 'release date', 'video release date', 'IMDb URL', 'unknown', 'Action', 'Adventure',
              'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
              'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western', 'genres']
    items = pd.read_csv('ml-100k/u.item', sep='|', names=i_cols, encoding='latin-1')

    movies_seen_by_user = ratings[(ratings['user_id'] == input_user_id)]

    movies_seen_by_user = pd.merge(movies_seen_by_user, items, on='movie_id')

    cols_of_interest = ['unknown', 'Action', 'Adventure',
                        'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
                        'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western']

    movies_seen_by_user_filtered = movies_seen_by_user[cols_of_interest]
    sum_of_genres_matrix = np.sum(movies_seen_by_user_filtered, axis=0)
    Sorted_sum_of_genres_matrix = sum_of_genres_matrix.sort_values(ascending=False)

    for i in range(0, 3):
        user_genres = user_genres + Sorted_sum_of_genres_matrix.index[i]
        if i < 2:
            user_genres = user_genres + ','

with open('ml-100k/u.result', mode='w+') as csv_file:
    r_cols = ['input_user_id', 'user_genres']
    if user_id.shape[0] == 1:
        writer = csv.DictWriter(csv_file, delimiter='|', fieldnames=r_cols)
        writer.writerow({'input_user_id': input_user_id, 'user_genres': user_genres})
    else :
        csv_file.close()
