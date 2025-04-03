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

#%%

txGenFeminino = df ['totalGenFeminino'].sum() / df['totalCandidaturas'].sum()
txCorRacaPreta = df ['totalCorRacaPreta'].sum() / df['totalCandidaturas'].sum()
txCorRacaNaoBranca = df ['totalCorRacaNaoBranca'].sum() / df['totalCandidaturas'].sum()
txCorRacaPretaParda = df ['totalCorRacaPretaParda'].sum() / df['totalCandidaturas'].sum()

#%%

from adjustText import adjust_text 
plt.figure(dpi=500)

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
plt.hlines(y=txCorRacaPreta, xmin=0.3, xmax=0.55, color='black', linestyles='--', label='Taxa Pretos')
plt.vlines(x=txGenFeminino, ymin=0.05, ymax=0.40, color='tomato', linestyles='--', label='Taxa Mulheres')

plt.legend(loc='lower right', title='Partidos', title_fontsize=10)

plt.savefig('..\\img\\partidos_cor_raca_genero.png')

# %%
