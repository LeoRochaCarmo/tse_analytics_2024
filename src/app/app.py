#%%

import streamlit as st
import pandas as pd
import sqlalchemy
import os
from utils import make_scatter, make_clusters

app_path = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.dirname(app_path)
base_path = os.path.dirname(src_path)
data_path = os.path.join(base_path, 'data')

@st.cache_data(ttl=60*60*24)
def create_df():
    filename = os.path.join(data_path, 'data_partidos.parquet')
    return pd.read_parquet(filename)

#%%

df = create_df()

welcome = '''
# TSE Analytics - Eleições 2024

Uma iniciativa Téo Me Why em conjunto com a comunidade de análise e ciência de dados ao vivo.
'''
st.markdown(welcome)

uf_options = list(df['SG_UF'].sort_values().unique())
uf_options.remove('BR')
uf_options = ['BR'] + uf_options

cargos_options = list(df['DS_CARGO'].unique())
# cargos_options.sort()
# cargos_options.remove('GERAL')
# cargos_options = ['GERAL'] + cargos_options

col1, col2 = st.columns(2, vertical_alignment='center', gap='medium')

with col1:
    estado = st.selectbox(label='Estado',
                          placeholder='Selecione o estado.',
                          index=None,
                          options=uf_options)
    size = st.checkbox(label='Tamanho das bolhas')
    cargo = st.selectbox(label='Cargo',
                          placeholder='Selecione um cargo',
                          index=None,
                          options=cargos_options)

with col2:                         
    n_cluster = st.number_input(label='Quantidade de clusters', format='%d', max_value=10, min_value=1)
    cluster = st.checkbox(label='Definir cluster')

data = df[(df['SG_UF'] == estado) & (df['DS_CARGO'] == cargo)].copy()

total_candidatos = data['totalCandidaturas'].sum()
st.markdown(f'Total de candidaturas: {total_candidatos}')
if cluster:
    data = make_clusters(data, n_cluster)

fig = make_scatter(data=data, size=size, cluster=cluster)

st.pyplot(fig)

#%%

df