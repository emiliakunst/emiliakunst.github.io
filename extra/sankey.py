import pandas as pd
import numpy as np
artists = pd.read_csv("./data/best_selling_artists_new.csv")

# print(artists.to_string())

sankey_array = []

for index, row in artists.iterrows():
    sankey_array.append([row['Country'],row['Artist'], row['TCU']])
    genre_count = 5-(15-row.count())
    sankey_array.append([row['Artist'],row['genre_1'], round(row['TCU']/genre_count, 4)])
    if type(row['genre_2']) == float:
        continue
    sankey_array.append([row['Artist'],row['genre_2'], round(row['TCU']/genre_count, 4)])
    if type(row['genre_3']) == float:
        continue
    sankey_array.append([row['Artist'],row['genre_3'], round(row['TCU']/genre_count, 4)])
    if type(row['genre_4']) == float:
        continue
    sankey_array.append([row['Artist'],row['genre_4'], round(row['TCU']/genre_count, 4)])
    if type(row['genre_5']) == float:
        continue
    sankey_array.append([row['Artist'],row['genre_5'], round(row['TCU']/genre_count, 4)])

# print(str(sankey_array))

sankey = pd.DataFrame(sankey_array, columns=['source', 'target', 'value'])

# print(sankey.to_string())

# sankey.to_csv("./data/sankey.csv", index=False)

rock = ['progressive rock', 'grunge', 'art rock', 'glam rock', 'psychedelic rock', 'blues rock', 'folk rock', 'hard rock', 'surf rock', 'soft rock', 'alternative rock', 'funk rock', 'rap rock', 'rock and roll', 'punk rock']
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
print(gframe)

gval = {i:0 for i in allg}
gcount = {i:0 for i in allg}

for index, row in gframe.iterrows():
    tar = row['target']
    count = allg.count(tar)
    gval[tar] += round(row['value']/count, 1)
    gcount[tar] = count

print(gval)

array = []

for sub in rock:
    array.append([sub, 'rock', gval[sub]])
for sub in pop:
    array.append([sub, 'pop', gval[sub]])
for sub in rnbsoul:
    array.append([sub, 'r&b and soul', gval[sub]])
for sub in blues:
    array.append([sub, 'blues', gval[sub]])
for sub in folk:
    array.append([sub, 'folk', gval[sub]])
for sub in metal:
    array.append([sub, 'metal', gval[sub]])
for sub in electronic:
    array.append([sub, 'electronic', gval[sub]])
for sub in jazz:
    array.append([sub, 'jazz', gval[sub]])
for sub in funk:
    array.append([sub, 'funk', gval[sub]])
for sub in hiphop:
    array.append([sub, 'hip-hop', gval[sub]])
for sub in punk:
    array.append([sub, 'punk', gval[sub]])
for sub in country:
    array.append([sub, 'country', gval[sub]])

genreframe = pd.DataFrame(array, columns=['source', 'target', 'value'])

print(genreframe)


genreframe.to_csv("./data/sankey_genres.csv", index=False)