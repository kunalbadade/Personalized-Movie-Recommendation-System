import pandas as pd
import numpy as np
import sys
import csv

# pass in column names for each CSV as the column name is not given in the file and read them using pandas.
# You can check the column names from the readme file
# Reading users file:

u_cols = ['user_id', 'age', 'sex', 'occupation', 'zip_code', 'user_name', 'password']
users = pd.read_csv('ml-100k/u.user', sep='|', names=u_cols, encoding='latin-1', dtype={'password': str})
user_id = users.shape[0]

with open('ml-100k/u.user', mode='a') as csv_file:
    u_cols = ['user_id', 'age', 'sex', 'occupation', 'zip_code', 'user_name', 'password']
    writer = csv.DictWriter(csv_file, delimiter='|', fieldnames=u_cols)

    writer.writerow({'user_id': user_id + 1,
                     'age': sys.argv[1],
                     'sex': sys.argv[2],
                     'occupation': sys.argv[3],
                     'zip_code': sys.argv[4],
                     'user_name': sys.argv[5],
                     'password': sys.argv[6]})
print(user_id + 1)
