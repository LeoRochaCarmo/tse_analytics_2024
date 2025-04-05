#%%

import streamlit as st
import pandas as pd
import sqlalchemy
from utils import make_scatter, make_clusters

engine = sqlalchemy.create_engine('sqlite:///..\\..\\data\\database.db')

with open('etl_partidos.sql', 'r') as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

df.head()

#%%

welcome = '''
# TSE Analytics - Eleições 2024

Uma iniciativa Téo Me Why em conjunto com a comunidade de análise e ciência de dados ao vivo.
'''
st.markdown(welcome)

uf_options = list(df['SG_UF'].unique())
uf_options.remove('BR')
uf_options = ['BR'] + uf_options

estado = st.sidebar.selectbox(label='Estado', 
                              placeholder='Selecione o estado...',
                              index=None,
                              options=uf_options)

size = st.sidebar.checkbox(label='Tamanho das bolhas')
cluster = st.sidebar.checkbox(label='Definir cluster')
n_cluster = st.sidebar.number_input(label='Quantidade de clusters', format='%d', max_value=10, min_value=1)

data = df[df['SG_UF'] == estado]

if cluster:
    data = make_clusters(data, n_cluster)

fig = make_scatter(data=data, size=size, cluster=cluster)

st.pyplot(fig)

#%%
