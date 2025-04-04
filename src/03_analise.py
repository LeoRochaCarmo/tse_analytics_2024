#%%

import pandas as pd
import sqlalchemy
import seaborn as sn
import matplotlib.pyplot as plt
import matplotlib.image as img
from matplotlib.offsetbox import OffsetImage, AnnotationBbox

with open ('partidos.sql', 'r') as open_file:
     query = open_file.read()

engine = sqlalchemy.create_engine("sqlite:///..\\data\\database.db")

df = pd.read_sql_query(query, engine)

#%%

txGenFeminino = df ['totalGenFeminino'].sum() / df['totalCandidaturas'].sum()
txCorRacaPreta = df ['totalCorRacaPreta'].sum() / df['totalCandidaturas'].sum()
txCorRacaNaoBranca = df ['totalCorRacaNaoBranca'].sum() / df['totalCandidaturas'].sum()
txCorRacaPretaParda = df ['totalCorRacaPretaParda'].sum() / df['totalCandidaturas'].sum()

#%%

from adjustText import adjust_text 
plt.figure(dpi=400)

sn.scatterplot(data=df, 
               x='txGenFemininoBR', 
               y='txCorRacaPretaBR')

texts = []
for i in df['SG_PARTIDO']:
     data = df[df['SG_PARTIDO'] == i]
     x = data['txGenFemininoBR'].values[0]
     y = data['txCorRacaPretaBR'].values[0]
     texts.append(plt.text(x, y, i, fontsize=9))

adjust_text(texts, 
            only_move={'points': 'y', 'texts': 'xy'}, 
            arrowprops=dict(arrowstyle='->', color='gray'))

plt.grid(True)
plt.title('Partidos: Cor vs Gênero - Eleições 2024')
plt.xlabel('Taxa de Mulheres')
plt.ylabel('Taxa de Pessoas Pretas')
plt.hlines(y=txCorRacaPreta, 
           xmin=0.3, 
           xmax=0.55, 
           color='black', 
           linestyles='--', 
           label=f'Pretos Geral: {100 * txCorRacaPreta:.2f}%')

plt.vlines(x=txGenFeminino, 
           ymin=0.05, 
           ymax=0.40, 
           color='tomato', 
           linestyles='--', 
           label=f'Mulheres Geral: {100 * txGenFeminino:.2f}%')

plt.legend(loc='lower right', title='Partidos', title_fontsize=10)

logo = img.imread('..\\img\\copyright.png')
imagebox = OffsetImage(logo, zoom=0.065, alpha=0.45)
ab = AnnotationBbox(imagebox, (0.76, 0.44), 
                    frameon=False, 
                    pad=0, 
                    xycoords='axes fraction', 
                    boxcoords='axes fraction', 
                    box_alignment=(0.5, 0.5))

plt.gca().add_artist(ab)

plt.savefig('..\\img\\partidos_cor_raca_genero.png')


#%%

from adjustText import adjust_text 
plt.figure(dpi=400)

sn.scatterplot(data=df, 
               x='txGenFemininoBR', 
               y='txCorRacaPretaBR',
               size='totalCandidaturas',
               sizes=(5,300))

texts = []
for i in df['SG_PARTIDO']:
     data = df[df['SG_PARTIDO'] == i]
     x = data['txGenFemininoBR'].values[0]
     y = data['txCorRacaPretaBR'].values[0]
     texts.append(plt.text(x, y, i, fontsize=9))

adjust_text(texts, 
            only_move={'points': 'y', 'texts': 'xy'}, 
            arrowprops=dict(arrowstyle='->', color='gray'))

plt.grid(True)
plt.title('Partidos: Cor vs Gênero - Eleições 2024')
plt.xlabel('Taxa de Mulheres')
plt.ylabel('Taxa de Pessoas Pretas')
plt.hlines(y=txCorRacaPreta, 
           xmin=0.3, 
           xmax=0.55, 
           color='black', 
           linestyles='--', 
           label=f'Pretos Geral: {100 * txCorRacaPreta:.2f}%')

plt.vlines(x=txGenFeminino, 
           ymin=0.05, 
           ymax=0.40, 
           color='tomato', 
           linestyles='--', 
           label=f'Mulheres Geral: {100 * txGenFeminino:.2f}%')

handles, labels = plt.gca().get_legend_handles_labels()
handles = handles[-2:]
labels = labels[-2:]

plt.legend(handles=handles, labels=labels, loc='lower right', title='Partidos', title_fontsize=10)

logo = img.imread('..\\img\\copyright.png')
imagebox = OffsetImage(logo, zoom=0.065, alpha=0.45)
ab = AnnotationBbox(imagebox, (0.76, 0.44), 
                    frameon=False, 
                    pad=0, 
                    xycoords='axes fraction', 
                    boxcoords='axes fraction', 
                    box_alignment=(0.5, 0.5))

plt.gca().add_artist(ab)

plt.savefig('..\\img\\partidos_cor_raca_genero_bolha_size.png')

# %%

from sklearn import cluster

model = cluster.KMeans(n_clusters=6, random_state=10)

x = df[['txGenFemininoBR', 'txCorRacaPretaBR']]

model.fit(x)

df['clusterBR'] = model.labels_

df.groupby('clusterBR')[['txGenFemininoBR']].count()

#%%

from adjustText import adjust_text 
plt.figure(dpi=400)

sn.scatterplot(data=df, 
               x='txGenFemininoBR', 
               y='txCorRacaPretaBR',
               size='totalCandidaturas',
               sizes=(5,300),
               hue='clusterBR',
               palette='viridis')

texts = []
for i in df['SG_PARTIDO']:
     data = df[df['SG_PARTIDO'] == i]
     x = data['txGenFemininoBR'].values[0]
     y = data['txCorRacaPretaBR'].values[0]
     texts.append(plt.text(x, y, i, fontsize=9))

adjust_text(texts, 
            only_move={'points': 'y', 'texts': 'xy'}, 
            arrowprops=dict(arrowstyle='->', color='gray'))

plt.grid(True)
plt.title('Partidos: Cor vs Gênero - Eleições 2024')
plt.suptitle('Maior a bolha, maior o tamanho do partido.', fontdict={'size': '9'})
plt.xlabel('Taxa de Mulheres')
plt.ylabel('Taxa de Pessoas Pretas')
plt.hlines(y=txCorRacaPreta, 
           xmin=0.3, 
           xmax=0.55, 
           color='black', 
           linestyles='--', 
           label=f'Pretos Geral: {100 * txCorRacaPreta:.2f}%')

plt.vlines(x=txGenFeminino, 
           ymin=0.05, 
           ymax=0.40, 
           color='tomato', 
           linestyles='--', 
           label=f'Mulheres Geral: {100 * txGenFeminino:.2f}%')

handles, labels = plt.gca().get_legend_handles_labels()
handles = handles[-2:]
labels = labels[-2:]

plt.legend(handles=handles, labels=labels, loc='lower right', title='Partidos', title_fontsize=10)

logo = img.imread('..\\img\\copyright.png')
imagebox = OffsetImage(logo, zoom=0.065, alpha=0.45)
ab = AnnotationBbox(imagebox, (0.76, 0.44), 
                    frameon=False, 
                    pad=0, 
                    xycoords='axes fraction', 
                    boxcoords='axes fraction', 
                    box_alignment=(0.5, 0.5))

plt.gca().add_artist(ab)

plt.savefig('..\\img\\partidos_cor_raca_genero_clusterBR.png')

#%%

df.sort_values('totalCandidaturas', ascending=False).reset_index(drop=True)
# %%
