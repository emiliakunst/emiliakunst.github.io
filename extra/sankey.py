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

print(sankey.to_string())

sankey.to_csv("./data/sankey.csv", index=False)