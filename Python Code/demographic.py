import pandas as pd
import numpy as np
import sys
import csv

# recommend movie
def recommendMoives(ratings, user_id):
    movies_ratings = ratings[(ratings['user_id'] == user_id)]
    return movies_ratings.sort_values(by='rating', ascending=False)

# parameter login user
input_user = int(sys.argv[1])
top_n = 20

u_cols = ['user_id', 'age', 'sex', 'occupation', 'zip_code', 'user_name', 'password']
users = pd.read_csv('ml-100k/u.user', sep='|', names=u_cols, encoding='latin-1', dtype={'password': str})
user = users[(users['user_id'] == input_user)]

# user information
user_id = user.user_id.min()
age = user.age.min()
sex = user.sex.min()
occupation = user.occupation.min()
zip_code = user.zip_code.min()

# similarity matrix
data_type = [('user_id', int), ('rating', int)]
data_matrix = np.array([(0, 0)], data_type)

for line in users.itertuples():
    tuple_column_1 = line[1];
    tuple_column_2 = 0;
    if user_id != line[1]:
        compare_age = 0;
        if age == line[2]:
            compare_age = 1;
        compare_sex = 0;
        if sex == line[3]:
            compare_sex = 1;
        compare_occupation = 0;
        if occupation == line[4]:
            compare_occupation = 1;
        compare_zip_code = 0;
        if zip_code == line[5]:
            compare_zip_code = 1;

        tuple_column_2 = compare_age + compare_sex + compare_occupation + compare_zip_code
    data_matrix = np.append(data_matrix, np.array([(tuple_column_1, tuple_column_2)], data_type))

data_matrix.sort(order='rating')
similarity_matrix = data_matrix[::-1]

# ratings
r_cols = ['user_id', 'movie_id', 'rating', 'unix_timestamp']
ratings = pd.read_csv('ml-100k/u.data', sep='\t', names=r_cols, encoding='latin-1')

# TODO don't know how to clarify type, temporary method
movies_ratings = ratings[(ratings['user_id'] == 0)]
for x in similarity_matrix:
    movies_ratings = movies_ratings.append(recommendMoives(ratings, x['user_id']))
    if movies_ratings.shape[0] >= top_n:
        break

# movies
i_cols = ['movie_id', 'movie_title', 'release date','video release date', 'IMDb URL', 'unknown', 'Action', 'Adventure',
'Animation', 'Children\'s', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western', 'genres']
items = pd.read_csv('ml-100k/u.item', sep='|', names=i_cols, usecols=["movie_id", "movie_title", "genres"], encoding='latin-1')

# get movies information
# TODO don't know how to clarify type, temporary method
recommend_movies = items[(items['movie_id'] == 0)]
for y in movies_ratings.movie_id.unique():
    recommend_movies = recommend_movies.append(items[(items['movie_id'] == y)])
    if recommend_movies.shape[0] >= top_n:
        break

# calculate precision
movies_ratings_input_user = ratings[(ratings['user_id'] == input_user)]
movies_ratings_input_user = movies_ratings_input_user.sort_values(by='rating', ascending=False).head(top_n)

common_movies_for_precision = pd.merge(recommend_movies, movies_ratings_input_user, how='inner', on=['movie_id'])
precision = (common_movies_for_precision.shape[0]/top_n)*100

with open('ml-100k/u.result', mode='w+') as csv_file:
    r_cols = ['movie_id', 'movie_title', 'genres']
    writer = csv.DictWriter(csv_file, delimiter='|', fieldnames=r_cols)

    for recommend_index in recommend_movies.get_values():
        writer.writerow({'movie_id': recommend_index[0],
                         'movie_title': recommend_index[1],
                         'genres': recommend_index[2]})

    # output precision result to the last line
    writer.writerow({'movie_id': precision,
                     'movie_title': precision,
                     'genres': precision})

