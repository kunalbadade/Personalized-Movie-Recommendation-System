import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
import sys
import csv

# parameter login user
input_user_id = int(sys.argv[1])
top_n = 20

# ratings
r_cols = ['user_id', 'movie_id', 'rating', 'unix_timestamp']
ratings = pd.read_csv('ml-100k/u.data', sep='\t', names=r_cols,encoding='latin-1')

# separate dataset
from sklearn.model_selection import train_test_split
train_data, test_data = train_test_split(ratings[(ratings['user_id'] == input_user_id)], test_size=0.25)

# movies
i_cols = ['movie_id', 'title' ,'release date','video release date', 'IMDb URL', 'unknown', 'Action', 'Adventure',
'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western','genres']
items = pd.read_csv('ml-100k/u.item', sep='|', names=i_cols, encoding='latin-1')

# filter the movies seen by user
movies_seen_by_user = pd.merge(train_data, items, on='movie_id')

# make fake record
cols_of_interest = ['unknown', 'Action', 'Adventure',
'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western']

movies_seen_by_user_filtered = movies_seen_by_user[cols_of_interest]
sum_of_genres_matrix = np.sum(movies_seen_by_user_filtered, axis=0)
Sorted_sum_of_genres_matrix = sum_of_genres_matrix.sort_values(ascending=False)

# make profile with 3 features
user_genres = ""
for i in range(0, 2):
    user_genres = user_genres + Sorted_sum_of_genres_matrix.index[i]
    if i < 1:
        user_genres = user_genres + ','

# filter the movies have not seen by user
movies_seen_by_user_and_All_other = pd.merge(movies_seen_by_user,items,
                                   left_on='movie_id',right_on='movie_id',
                                   how='outer')

movies_not_seen_by_user = movies_seen_by_user_and_All_other[(movies_seen_by_user_and_All_other['user_id'] != input_user_id)]
movies_not_seen_by_user = movies_not_seen_by_user.reset_index();

# add record at index 0
movies_not_seen_by_user.at[0, 'genres_y'] = user_genres

# call TfIdf
tf = TfidfVectorizer(analyzer='word',ngram_range=(1, 2),min_df=0, stop_words='english')
tfidf_matrix = tf.fit_transform(movies_not_seen_by_user['genres_y'])

# calculate cosine similarity
cosine_sim = linear_kernel(tfidf_matrix, tfidf_matrix)
# Build a 1-dimensional array with movie titles
titles = movies_not_seen_by_user['title_y']
genres = movies_not_seen_by_user['genres_y']
movie_ids = movies_not_seen_by_user['movie_id']

# Function that get movie recommendations based on the cosine similarity score of movie genres
idx = 0
sim_scores = list(enumerate(cosine_sim[idx]))
sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
sim_scores = sim_scores[1:top_n+1]
movie_indices = [i[0] for i in sim_scores]
recommend_movies_titles = titles.iloc[movie_indices].head(top_n)
recommend_movies_genres = genres.iloc[movie_indices].head(top_n)
recommend_movie_ids = movie_ids.iloc[movie_indices].head(top_n)

# calculate precision
common_movies_for_precision = pd.merge(test_data, recommend_movie_ids.to_frame(), how='inner', on=['movie_id'])
precision = (common_movies_for_precision.shape[0]/top_n)*100

with open('ml-100k/u.result', mode='w+') as csv_file:
    r_cols = ['movie_id', 'movie_title', 'genres']
    writer = csv.DictWriter(csv_file, delimiter='|', fieldnames=r_cols)

    for i, v in zip(recommend_movies_titles.items(), recommend_movies_genres.items()):
        writer.writerow({'movie_id': i[0],
                         'movie_title': i[1],
                         'genres': v[1]
                         })

    # output precision result to the last line
    writer.writerow({'movie_id': precision,
                 'movie_title': precision,
                 'genres': precision
                 })
