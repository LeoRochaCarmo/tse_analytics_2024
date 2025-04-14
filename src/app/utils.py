import seaborn as sn
import pandas as pd
from adjustText import adjust_text
import matplotlib.pyplot as plt
import matplotlib.image as img
import streamlit as st
from matplotlib.offsetbox import OffsetImage, AnnotationBbox
from sklearn import cluster

def make_scatter(data, x, y, x_label, y_label, cluster=False, size=False):

    config = {
         'data':data, 
         'x': x, 
         'y': y,
         'size':'totalCandidaturas',
         'sizes':(5,300),
         'hue':'cluster',
         'palette':'viridis',
         'alpha': 0.6,
    }

    if not cluster:
         del config['hue']
         del config['palette']

    if not size:
         del config['size']
         del config['sizes']

    fig = plt.figure(dpi=400)

    sn.scatterplot(**config)

    texts = []
    for i in data['SG_PARTIDO'].unique():
         data_tmp = data[data['SG_PARTIDO'] == i]
         x_pos = data_tmp[x].values[0]
         y_pos = data_tmp[y].values[0]
         texts.append(plt.text(x_pos, y_pos, i, fontsize=9))

    adjust_text(texts, 
                only_move={'points': 'y', 'texts': 'xy'}, 
                arrowprops=dict(arrowstyle='->', color='gray'))

    plt.grid(True)
    plt.suptitle(f'Partidos: {x_label} vs {y_label} - Eleições 2024')

    if size:
        plt.title('Maior a bolha, maior o tamanho do partido.', fontsize=9)

    plt.xlabel(x_label)
    plt.ylabel(y_label)

    total_candidaturas = data['totalCandidaturas'].sum()
    
#     if total_candidaturas and not pd.isna(total_candidaturas):
    if x == 'txGenFeminino' and y == 'txCorRacaPreta': 
        txCorRacaPreta = data['totalCorRacaPreta'].sum() / total_candidaturas
        txGenFeminino = data['totalGenFeminino'].sum() / total_candidaturas
#     else:
#          txCorRacaPreta = float('nan')
#          txGenFeminino = float('nan')
         
        xmin, xmax = plt.xlim()

        plt.hlines(y=txCorRacaPreta, 
                       xmin=xmin, 
                       xmax=xmax, 
                       color='black', 
                       linestyles='--', 
                       label=f'Pretos Geral: {f"{100 * txCorRacaPreta:.2f}" if txCorRacaPreta > 0 else "0.00"}%')

        ymin, ymax = plt.ylim()

        plt.vlines(x=txGenFeminino, 
                       ymin=ymin,
                       ymax=ymax, 
                       color='tomato', 
                       linestyles='--', 
                       label=f'Mulheres Geral: {f"{100 * txGenFeminino:.2f}" if txGenFeminino > 0 else "0.00"}%')
    
    
        handles, labels = plt.gca().get_legend_handles_labels()
        handles = handles[-2:]
        labels = labels[-2:]

        plt.legend(handles=handles, labels=labels, 
                   loc='lower left', title='Partidos', 
                   title_fontsize=10, bbox_to_anchor=(0.55, -0.35))

    return fig

def make_clusters(data, n=6):
     model = cluster.KMeans(n_clusters=n, random_state=42)
     model.fit(data[['txGenFeminino', 'txCorRacaPreta']])
     data['cluster'] = model.labels_
     return data