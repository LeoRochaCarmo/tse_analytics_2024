import seaborn as sn
from adjustText import adjust_text
import matplotlib.pyplot as plt
import matplotlib.image as img
import streamlit as st
from matplotlib.offsetbox import OffsetImage, AnnotationBbox

def make_scatter(data, cluster=False, size=False):

    config = {
         'data':data, 
         'x':'txGenFeminino', 
         'y':'txCorRacaPreta',
         'size':'totalCandidaturas',
         'sizes':(5,300),
         'hue':'clusterBR',
         'palette':'viridis'
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
    for i in data['SG_PARTIDO']:
         data_tmp = data[data['SG_PARTIDO'] == i]
         x = data_tmp['txGenFeminino']
         y = data_tmp['txCorRacaPreta']
         texts.append(plt.text(x, y, i, fontsize=9))

    adjust_text(texts, 
                only_move={'points': 'y', 'texts': 'xy'}, 
                arrowprops=dict(arrowstyle='->', color='gray'))

    plt.grid(True)
    plt.suptitle('Partidos: Cor vs Gênero - Eleições 2024')

    if size:
        plt.title('Maior a bolha, maior o tamanho do partido.', fontsize=9)

    plt.xlabel('Taxa de Mulheres')
    plt.ylabel('Taxa de Pessoas Pretas')

    txCorRacaPreta = data['totalCorRacaPreta'].sum() / data['totalCandidaturas'].sum()
    txGenFeminino = data['totalGenFeminino'].sum() / data['totalCandidaturas'].sum()

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

    plt.legend(handles=handles, labels=labels, loc='lower right', title='Partidos', title_fontsize=10)

    return fig
