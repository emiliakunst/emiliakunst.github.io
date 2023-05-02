import pandas as pd
import numpy as np
sankey = pd.read_csv("./data/sankey.csv")

rock = ['progressive rock', 'grunge', 'pop rock', 'art rock', 'glam rock', 'psychedelic rock', 'blues rock', 'folk rock', 'hard rock', 'surf rock', 'soft rock', 'alternative rock', 'funk rock', 'rap rock', 'rock and roll', 'punk rock']
pop = ['country pop', 'j-pop', 'teen pop', 'dance pop', 'latin pop', 'folk pop', 'pop punk','adult contemporary', 'pop rock', 'electropop', 'dance-pop']
rnbsoul = ['soul', 'gospel', 'neo soul', 'r&b']
blues = ['blues rock', ]
folk = ['folk rock', 'folk pop', 'celtic']
metal = ['heavy metal', 'glam metal', 'thrash metal', 'nu metal']
electronic = ['disco', 'electropop', 'dance-pop', 'electronica', 'hip house', 'edm', 'new-age']
jazz = ['swing', 'smooth jazz']
funk = ['funk rock']
hiphop = ['rap rock']
punk = ['pop punk', 'punk rock']
country = ['country pop']

genres = [rock, pop, rnbsoul, blues, folk, metal, electronic, jazz, funk, hiphop, punk, country]

allg = []
for i in genres: allg += i 

gframe = sankey.loc[sankey['target'].isin(allg)]
# print(gframe)

gval = {i:0 for i in allg}
gcount = {i:0 for i in allg}

for index, row in gframe.iterrows():
    tar = row['target']
    count = allg.count(tar)
    gval[tar] += round(row['value']/count, 1)
    gcount[tar] = count

# print(gval)

array = []

for sub in rock:
    if gval[sub] > 0:
        array.append([sub, 'rock', gval[sub]])
for sub in pop:
    if gval[sub] > 0:
        array.append([sub, 'pop', gval[sub]])
for sub in rnbsoul:
    if gval[sub] > 0:
        array.append([sub, 'r&b and soul', gval[sub]])
for sub in blues:
    if gval[sub] > 0:
        array.append([sub, 'blues', gval[sub]])
for sub in folk:
    if gval[sub] > 0:
        array.append([sub, 'folk', gval[sub]])
for sub in metal:
    if gval[sub] > 0:
        array.append([sub, 'metal', gval[sub]])
for sub in electronic:
    if gval[sub] > 0:
        array.append([sub, 'electronic', gval[sub]])
for sub in jazz:
    if gval[sub] > 0:
        array.append([sub, 'jazz', gval[sub]])
for sub in funk:
    if gval[sub] > 0:
        array.append([sub, 'funk', gval[sub]])
for sub in hiphop:
    if gval[sub] > 0:
        array.append([sub, 'hip-hop', gval[sub]])
for sub in punk:
    if gval[sub] > 0:
        array.append([sub, 'punk', gval[sub]])
for sub in country:
    if gval[sub] > 0:
        array.append([sub, 'country', gval[sub]])

genreframe = pd.DataFrame(array, columns=['source', 'target', 'value'])

print(genreframe)


genreframe.to_csv("./data/sankey_genres.csv", index=False)