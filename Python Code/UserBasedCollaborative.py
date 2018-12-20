import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import csv
import sys

# parameter login user
input_user_id = int(sys.argv[1])
top_n = 20
knn = 10

#Reading users file:
u_cols = ['user_id', 'age', 'sex', 'occupation', 'zip_code']
users = pd.read_csv('ml-100k/u.user', sep='|', names=u_cols,encoding='latin-1')

#Reading ratings file:
r_cols = ['user_id', 'movie_id', 'rating', 'unix_timestamp']
ratings = pd.read_csv('ml-100k/u.data', sep='\t', names=r_cols,encoding='latin-1')

#Reading items file:
i_cols = ['movie_id', 'movie_title', 'release date', 'video release date', 'IMDb URL', 'unknown', 'Action', 'Adventure',
'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western', 'genres']
items = pd.read_csv('ml-100k/u.item', sep='|', names=i_cols, encoding='latin-1')

n_users = users.shape[0]
n_items = items.shape[0]

# create matrix user * item
data_matrix = np.zeros((n_users, n_items))
for line in ratings.itertuples():
    data_matrix[line[1]-1, line[2]-1] = line[3]

from sklearn.metrics.pairwise import pairwise_distances
# calculate similarity
user_similarity = 1 - pairwise_distances(data_matrix, metric='cosine')

# use KNN to make recommendation
user_similarity_input_user = user_similarity[input_user_id-1]
user_similarity_input_user[input_user_id-1] = 0

# order similar user
user_similarity_input_user_copy = np.copy(user_similarity_input_user)
user_similarity_input_user_copy.sort(axis=0)
user_similarity_input_user_copy = user_similarity_input_user_copy[::-1]

# get knn similar users
knn_similarity = {}
for i in range(0, knn):
    knn_similarity[user_similarity_input_user_copy[i]] = user_similarity_input_user_copy[i]

for i in range(0, user_similarity_input_user.shape[0]):
    if knn_similarity.get(user_similarity_input_user[i]) == None:
        user_similarity_input_user[i] = 0

# predict function
def predict(ratings, similarity, type='user'):
    if type == 'user':
        pred = similarity.dot(ratings)
    elif type == 'item':
        pred = ratings.dot(similarity)
    return pred

# make recommendation
user_prediction = predict(data_matrix, user_similarity_input_user, type='user')

# create result matrix
i = 0
data_type = [('movie_id', int), ('similarity', float)]
data_matrix = np.array([(0, 0)], data_type)
for line in user_prediction:
    i += 1
    data_matrix = np.append(data_matrix, np.array([(i, line)], data_type))

# order by rating
data_matrix.sort(order='similarity')
similarity_matrix = data_matrix[::-1]

user_specific_ratings = ratings[(ratings['user_id'] == input_user_id)]
# TODO don't know how to clarify type, temporary method
recommend_movies = items[(items['movie_id'] == 0)]
for (iter_movie_id, iter_similarity) in similarity_matrix:
    if_no_exist = True
    for j in user_specific_ratings.movie_id:
        if iter_movie_id == j:
            if_no_exist = False
            break
    if if_no_exist and recommend_movies.shape[0] < top_n:
        recommend_movies = recommend_movies.append(items[(items['movie_id'] == iter_movie_id)])

# calculate precision
supervise_items = ratings[(ratings['unix_timestamp'] == input_user_id)]
precision_count = 0
for recommend_movie_id in recommend_movies.movie_id:
    for supervise_movie_id in supervise_items.movie_id:
        if recommend_movie_id == supervise_movie_id:
            precision_count += 1

precision = 0
if supervise_items.shape[0] != 0:
    precision = precision_count/supervise_items.shape[0]*100

with open('ml-100k/u.result', mode='w+') as csv_file:
    r_cols = ['movie_id', 'movie_title', 'genres']
    writer = csv.DictWriter(csv_file, delimiter='|', fieldnames=r_cols)
    for recommend_movies_index in recommend_movies.get_values():
        writer.writerow({'movie_id': recommend_movies_index[0],
                         'movie_title': recommend_movies_index[1],
                         'genres': recommend_movies_index[24]})

    # output precision result to the last line
    writer.writerow({'movie_id': precision,
                     'movie_title': precision,
                     'genres': precision})

