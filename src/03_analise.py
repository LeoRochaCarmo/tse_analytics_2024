#%%

import pandas as pd
import sqlalchemy
import seaborn as sn
import matplotlib.pyplot as plt

with open ('partidos.sql', 'r') as open_file:
     query = open_file.read()

engine = sqlalchemy.create_engine("sqlite:///..\\data\\database.db")

df = pd.read_sql_query(query, engine)

df.head()
df.columns
#%%

sn.scatterplot(data=df, x='txGenFemininoBR', y='txCorRacaPretaBR')