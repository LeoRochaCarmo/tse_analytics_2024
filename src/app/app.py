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

features_map = {
'PERCENTUAL FEMININO': 'txGenFeminino',
'PERCENTUAL RAÇA PRETA': 'txCorRacaPreta',
'PERCENTUAL RAÇA PRETA PARDA': 'txCorRacaPretaParda',
'PERCENTUAL RAÇA NÃO BRANCA': 'txCorRacaNaoBranca',
'MÉDIA BENS TOTAL': 'avgBens',
'MÉDIA BENS SEM ZERO': 'avgBensNotZero',
'PERCENTUAL ESTADO CIVIL CASADO(A)': 'txEstadoCivilCasado',
'PERCENTUAL ESTADO CIVIL SOLTEIRO(A)': 'txEstadoCivilSolteiro',
'PERCENTUAL ESTADO CIVIL DIVORCIADO(A)': 'txEstadoCivilSeparadoDivorciado',
'MÉDIA IDADE': 'avgIdade',
}

features_options = list(features_map.keys())
features_options.sort()

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
cargos_options.sort()
cargos_options.remove('GERAL')
cargos_options = ['GERAL'] + cargos_options

# Definição do estado e cargo
col1, col2 = st.columns(2, vertical_alignment='center', gap='medium')
with col1:
    estado = st.selectbox(label='Estado',
                          placeholder='Selecione o estado.',
                          index=0,
                          options=uf_options)

with col2:                         
    cargo = st.selectbox(label='Cargo',
                          placeholder='Selecione um cargo',
                          index=0,
                          options=cargos_options)

# Definição dos eixos  
col1, col2 = st.columns(2, vertical_alignment='center', gap='medium')
with col1:
    x_option = st.selectbox(label='Eixo x', options=features_options, index=6)
    x = features_map[x_option]
    features_options.remove(x_option)

with col2:
    y_option = st.selectbox(label='Eixo y', options=features_options, index=7)
    y = features_map[y_option]

# Definição do uso de cluster
col1, col2 = st.columns(2, vertical_alignment='center', gap='medium')
with col1:
    cluster = st.checkbox(label='Definir cluster')
    if cluster:
        n_cluster = st.number_input(label='Quantidade de clusters', format='%d', max_value=10, min_value=1)

with col2:
    size = st.checkbox(label='Tamanho das bolhas')

data = df[(df['SG_UF'] == estado) & (df['DS_CARGO'] == cargo)].copy()

total_candidatos = data['totalCandidaturas'].sum()
st.markdown(f'Total de candidaturas: {total_candidatos}')

if cluster:
    data = make_clusters(data=data, features=[x,y], n=n_cluster)

fig = make_scatter(data=data, x=x, 
                   y=y, x_label=x_option, 
                   y_label=y_option, 
                   size=size, cluster=cluster)

st.pyplot(fig)

#%%